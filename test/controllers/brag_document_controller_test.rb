require "test_helper"

class BragDocumentControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get brag_document_index_url
    assert_response :success
  end
end
