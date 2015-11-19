shared_examples "require_sign_in" do
  it "redirects to the root path" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples "tokenable" do
  it "generates a random token with the object is created" do
    expect(object.reload.token).to be_present
  end
end
