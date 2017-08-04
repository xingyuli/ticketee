require 'rails_helper'

RSpec.describe 'API errors', type: :api do

  it 'making a request with no token' do
    get '/api/v1/projects.json', token: ''
    error = { error: 'Token is invalid.' }
    expect(last_response.body).to eql(error.to_json)
  end

end