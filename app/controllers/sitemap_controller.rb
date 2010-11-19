class SitemapController < ApplicationController

  def sitemap
    @pages = Goldberg::ContentPage.find(:all)
    headers["Last-Modified"] = @pages[0].updated_at.httpdate if @pages[0]
    render :layout => false
  end
end
