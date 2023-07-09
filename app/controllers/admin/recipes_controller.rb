class Admin::RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def show
  end

  def destroy
  end
  
end
