<template>
  <div>
    <!-- 新規作成部分 -->
    <div class="row">
      <div class="col s10 m11">
        <input v-model="newTask" class="form-control" placeholder="Add your task!!">
      </div>
      <div class="col s2 m1">
        <div v-on:click="createTodo" class="btn-floating waves-effect waves-light red">
          <i class="material-icons">add</i>
        </div>
      </div>
    </div>
    <!-- リスト表示部分 -->
    <div>
      <ul class="collection">
        <li v-for="todo in todos" v-if="!todo.is_done" v-bind:id="'row_' + todo.id" class="collection-item">
          <input type="checkbox" v-on:change="doneTodo(todo.id)" v-bind:id="'todo_' + todo.id" />
          <label :for="'todo_' + todo.id">{{ todo.task }}</label>
        </li>
      </ul>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div v-on:click="displayFinishedTasks" class="btn">Display finished tasks</div>
    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" class="display_none">
      <ul class="collection">
        <li v-for="todo in todos" v-if="todo.is_done" :id="'row_' + todo.id" class="collection-item">
          <input type="checkbox" :id="'todo_' + todo.id" checked="checked"> <label :for="'todo_' + todo.id" class="line-through">{{ todo.task }}</label>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      todos: [],
      newTask: ''
    }
  },
  methods: {
    fetchTodo: function() {
      axios.get('/todos').then((response) => {
        for(var i = 0; i < response.data.todos.length; i++) {
          this.todos.push(response.data.todos[i])
        }
      }, (error) => {
        console.log(error)
      })
    },
    doneTodo: function(id) {
      axios.put('/todos/' + id, { todo: { is_done: 1 } }).then((response) => {
        this.moveToFinished(id)
      })
    },
    createTodo: function() {
      if (!this.newTask) return
      axios.post('/todos', { todo: { task: this.newTask } }).then((response) => {
        this.todos.unshift(response.data.todo)
        this.newTask = ''
      }, (error) => {
        console.log(error)
      })
    },
    displayFinishedTasks: function() {
      document.querySelector('#finished-tasks').classList.toggle('display_none');
    },
    moveToFinished: function(id) {
      var el = document.querySelector('#row_' + id)
      var el_clone = el.cloneNode(true)
      el.classList.add('display_none')
      el_clone.getElementsByTagName('input')[0].checked = 'checked'
      el_clone.getElementsByTagName('label')[0].classList.add('line-through')
      el_clone.getElementsByTagName('label')[0].classList.remove('word-color-black')
      var li = document.querySelector('#finished-tasks > ul > li:first-child')
      document.querySelector('#finished-tasks > ul').insertBefore(el_clone, li)
    }
  },
  mounted: function() {
    this.fetchTodo()
  }
}
</script>

<style scoped>
  [v-cloak] {
    display: none;
  }
  .display_none {
    display:none;
  }
  .line-through {
    text-decoration: line-through;
  }
</style>
