require 'ftools'
require 'rubygems'
require 'tempfile'

require 'google_chart'
include GoogleChart

require 'grit'
include Grit

class GitChart
  def initialize(size = '1000x300', threed = true, repo = '.', branch = 'master')
    begin
      @repo = Repo.new(repo)
    rescue
      raise "Could not initialize Grit instance."
    end
    @size = size
    @threed = threed
    @branch = branch
    if repo == '.'
      rpath = Dir.getwd
    else
      rpath = repo
    end
    @html = <<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head profile="http://purl.org/uF/2008/03">
		<meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
		<style type="text/css">
		  * { margin: 0; padding: 0; }
		  body { width: 1000px; margin: 50px auto; overflow: auto; text-align: center; font-size: 13px; }
		  h1 { font-weight: normal; font-size: 20px; }
		  table { border: none; margin: 20px auto; width: 500px; }
		  tr { border: none; }
		  td { border: none; padding: 7px; }
		  td.key { background-color: #c7e4e5; width: 145px; font-weight: bold; font-size: 11px; }
		</style>
		<title>gitchart output</title>
	</head>
	<body>
	  <h1>Git Repository Stats</h1>
	  <p>These stats were generated by <a href="http://github.com/hans/git-chart"><code>git-chart</code></a>.
    <table cellpadding="0" cellspacing="0">
      <tr>
        <td class="key">repository location:</td>
        <td>#{rpath}</td>
      </tr>
      <tr>
        <td class="key">generated on:</td>
        <td>#{Time.now.to_s}</td>
      </tr>
    </table>
    
EOF
  end
  
  def run
    @commits = @repo.commits @branch, 100
    chart_authors
    chart_commits
    chart_extensions
    output
  end
  
  def chart_authors
    authors = {}
    @commits.each do |c|
      if authors[c.author.to_s]
        authors[c.author.to_s] += 1
      else
        authors[c.author.to_s] = 1
      end
    end
    PieChart.new(@size, 'Repository Authors', @threed) do |pc|
      authors.each do |a, num|
        pc.data a, num
      end
      @html += "<img src='#{pc.to_url}' alt='Repository Authors' /><br/>"
    end
  end
  
  def chart_commits
    weeks = Array.new 53, 0
    @commits.each do |c|
      time = Time.parse c.committed_date.to_s
      week = time.strftime '%U'
      weeks[week.to_i] ||= 0
      weeks[week.to_i] += 1
    end
    BarChart.new(@size, 'Commit Frequency', :vertical, @threed) do |bc|
      bc.data '', weeks
      bc.axis :y, { :range => [0, weeks.max] }
      @html += "<img src='#{bc.to_url}' alt='Commit Frequency' /><br/>"
    end
  end
  
  def chart_extensions
    @extensions = {}
    @tree = @commits.first.tree
    extensions_add_tree @tree
    PieChart.new(@size, 'Popular Extensions', @threed) do |pc|
      @extensions.each do |ext, num|
        pc.data ext, num
      end
      @html += "<img src='#{pc.to_url}' alt='Popular Extensions' /><br/>"
    end
  end
  def extensions_add_tree(tree)
    tree.contents.each do |el|
      if Blob === el
        extensions_add_blob el
      elsif Tree === el
        extensions_add_tree el
      end
    end
  end
  def extensions_add_blob(el)
    ext = File.extname el.name
    if ext == ''
      @extensions['Other'] += 1 rescue @extensions['Other'] = 1
    else
      @extensions[ext] += 1 rescue @extensions[ext] = 1
    end
  end
  
  def output
    @html += <<EOF
  </body>
</html>
EOF
    t = Tempfile.new 'gitchart-' + Time.now.to_i.to_s
    t.print @html
    t.flush
    f = t.path + '.html'
    File.move t.path, f
    `open #{f}`
    #File.delete(f.path)
  end
end