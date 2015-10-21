shared_examples "require_sign_in" do
  it "redirects to the root path" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to root_path
  end
end
