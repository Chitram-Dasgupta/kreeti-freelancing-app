# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController do
  let(:admin) { create(:user, :admin) }

  describe 'GET #index' do
    context 'when admin is logged in' do
      before do
        session[:user_id] = admin.id
        get :index
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when user is not logged in' do
      before do
        get :index
      end

      it 'redirects to new_user_path' do
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'GET #show' do
    context 'when project exists' do
      let(:project) { create(:project) }

      before do
        get :show, params: { id: project.id }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when project does not exist' do
      before do
        get :show, params: { id: -1 }
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is a client' do
      let(:client) { create(:user, :client) }

      before do
        session[:user_id] = client.id
        get :new
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end
    end

    context 'when user is not a client' do
      before do
        get :new
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe 'POST #create' do
    let(:client) { create(:user, :client) }
    let(:category) { create(:category) }

    before do
      session[:user_id] = client.id
    end

    context 'when user is a client with valid parameters' do
      let(:valid_params) { { project: attributes_for(:project, user: client, category_ids: [category.id]) } }

      it 'creates a new project' do
        expect { post :create, params: valid_params }.to change(Project, :count).by(1)
      end

      it 'redirects to the created project' do
        post :create, params: valid_params
        expect(response).to redirect_to(projects_path)
      end
    end

    context 'when user is a client with invalid parameters' do
      let(:invalid_params) { { project: attributes_for(:project, title: '') } }

      it 'does not create a new project' do
        expect { post :create, params: invalid_params }.not_to change(Project, :count)
      end
    end

    context 'when user is not a client' do
      let(:valid_params) { { project: attributes_for(:project, user: client, category_ids: [category.id]) } }

      before do
        post :create, params: valid_params
      end

      it 'redirects to projects index page path' do
        expect(response).to redirect_to(projects_path)
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user:) }

    context 'when the project is editable by the user' do
      it 'renders the edit template' do
        session[:user_id] = user.id
        get :edit, params: { id: project.id }
        expect(response).to be_successful
      end
    end

    context 'when the project is not editable by the user' do
      it 'redirects to root_path' do
        other_user = create(:user)
        session[:user_id] = other_user.id

        get :edit, params: { id: project.id }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the project is not found' do
      it 'redirects to root_path' do
        session[:user_id] = user.id
        get :edit, params: { id: 'invalid_id' }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user:) }

    context 'when the project is not awarded' do
      before do
        session[:user_id] = user.id
        put :update, params: { id: project.id, project: { title: 'New Title' } }
      end

      it 'updates the project and redirects to the project page' do
        expect(response).to redirect_to(project)
      end

      it 'redirects to the project page' do
        project.reload
        expect(project.title).to eq('New Title')
      end
    end

    context 'when the project is awarded' do
      before do
        session[:user_id] = user.id
        project.update(has_awarded_bid: true)

        put :update, params: { id: project.id, project: { title: 'New Title' } }
      end

      it 'does not update the project and redirects to the project page with a notice' do
        expect(response).to redirect_to(project)
      end

      it 'redirects to the project page' do
        project.reload
        expect(project.title).not_to eq('New Title')
      end
    end

    context 'when the project is not found' do
      it 'redirects to the root path' do
        session[:user_id] = user.id

        put :update, params: { id: 999, project: { title: 'New Title' } }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the project is not updated successfully' do
      it 'renders the edit template with an error flash message' do
        session[:user_id] = user.id
        project = create(:project, user:)
        put :update, params: { id: project.id, project: { title: '' } }

        project.reload
        expect(project.title).not_to eq('')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:project) { create(:project, user:) }

    context 'when the project exists' do
      it 'destroys the project and redirects to the projects index page' do
        session[:user_id] = user.id
        delete :destroy, params: { id: project.id }

        expect(response).to redirect_to(projects_path)
      end
    end

    context 'when the project does not exist' do
      it 'does not destroy the project' do
        session[:user_id] = user.id

        expect { delete :destroy, params: { id: -1 } }.not_to change(Project, :count)
      end
    end
  end

  describe 'GET #search' do
    let(:category_name) { 'example_category' }

    context 'when projects matching the category name exist' do
      it 'returns a successful response and assigns the matching projects to @projects' do
        category = create(:category, name: category_name)
        create(:project, categories: [category])
        create(:project, categories: [category])

        get :search, params: { search: category_name }

        expect(response).to be_successful
      end
    end

    context 'when no projects matching the category name exist' do
      it 'returns a successful response and assigns an empty array to @projects' do
        get :search, params: { search: 'nonexistent_category' }

        expect(response).to be_successful
      end
    end
  end
end
