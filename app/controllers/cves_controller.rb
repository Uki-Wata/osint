class CvesController < ApplicationController
  def index
    @cves = Cve.fetch_and_format
  end
end
