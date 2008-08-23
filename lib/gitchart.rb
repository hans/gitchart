require 'rubygems'

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
  end
  
  def run
    @commits = @repo.commits @branch, 100
    chart_authors
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
      puts pc.to_url
    end
  end
end