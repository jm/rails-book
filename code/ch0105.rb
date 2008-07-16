def comment
  Post.find(params[:id]).comments.create(params[:comment])
  flash[:notice] = "Your comment was successfully added"
  redirect_to :action => "show", :id => params[:id]
end