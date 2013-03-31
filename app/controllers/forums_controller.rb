# encoding: utf-8
class ForumsController < ApplicationController
  before_filter :find_forums
  before_filter :get_order
  caches_page   :index, :if => Proc.new { |c| c.request.format.atom? && !c.request.ssl? }
  caches_page   :show,  :if => Proc.new { |c| c.request.format.atom? && !c.request.ssl? }

  def index
    @nodes = Node.old_listing(Post, @order, params[:page])
    respond_to do |wants|
      wants.html
      wants.atom
    end
  end

  def show
    @forum = Forum.find(params[:id])
    @posts = @forum.posts.with_node_ordered_by(@order).page(params[:page])
    flash.now[:alert] = "Attention, ce forum a été archivé et n'accueille plus de nouvelles discussions." unless @forum.active?
    respond_to do |wants|
      wants.html
      wants.atom
    end
  end

protected

  def find_forums
    @forums = Forum.sorted
  end

  def get_order
    @order = params[:order]
    @order = "created_at" unless VALID_ORDERS.include?(@order)
  end

end
