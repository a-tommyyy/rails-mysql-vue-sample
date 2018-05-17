class TodosController < ApplicationController

  def index
    @todos = Todo.order(updated_at: 'DESC')
  end

  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render :show, status: 200
    else
      render :json, @task.errors, status: 400
    end
  end

  def update
    @todo = Todo.find(params[:id])

    if @todo.update(todo_params)
      render :show, status: 200
    else
      render :json, @task.errors, status: 400
    end
  end

  private

  def todo_params
    params.fetch(:todo, {}).permit(:task, :is_done)
  end

end
