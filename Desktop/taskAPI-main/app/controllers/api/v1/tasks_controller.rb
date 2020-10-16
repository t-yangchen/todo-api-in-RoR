class Api::V1::TasksController < ApplicationController
 
    before_action :find_task, only: [:show, :update, :destroy]
    before_action :authorized, only: [:show, :update, :create, :destroy, :complete, :incomplete]

        
    def index
        @tasks = Task.all
        render json: @tasks, status: 200
    end

    def show
            render json: @task            
    end

    def create
        @task = Task.new(task_params)
        if @task.save 
            render json: @task
        else
            render json: {error: 'Unable to add the task'}, status: 400
        end
    end

    def update
        if @task
            @task.update(task_params)
            render json: { message: 'Task updated successfully'}, status: 200
        else
            render json: { error: 'Unable to update the task'}, status: 400
        end
    end

    def destroy
        if @task
            @task.destroy
            render json: {message: 'task successfully deleted.'}, status: 200
        else
            render json: { error: 'Unable to delete task'}, status: 400
        end   
    end
    
    def complete
        @task = Task.where(iscomplete: true)
        render json: @task        
    end

    def incomplete
        @task = Task.where(iscomplete: false)
        render json: @task        
    end    

    private 
    def task_params
        params.permit(:taskname, :user_id, :iscomplete)
    end

    def find_task
        @task = Task.find(params[:id])
    end
end
