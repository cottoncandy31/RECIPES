class Public::HomesController < ApplicationController
  def top
  end
  
  def bookmarks
  @bookmarks = Bookmark.where(user_id: current_user.id)
  end

end
