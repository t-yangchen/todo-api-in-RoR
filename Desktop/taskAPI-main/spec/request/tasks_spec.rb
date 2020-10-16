require 'rails_helper'

describe 'Tasks', type: :request do
    it 'return all tasks' do
        FactoryBot.create(:task, taskname: 'complete selise assignment', iscomplete: false)
        FactoryBot.create(:task, taskname: 'get that job at selise', iscomplete: false)
        get '/api/v1/tasks'

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).size).to eq(2)
    end 
end