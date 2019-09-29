pipeline {
  agent any
  
  stages {
    stage('CheckOut') {
      // environment {
      // username: password = credentials('c65fcf11-b58c-46a3-b7bd-1464feefe5f7')
      // }
      steps {
        sh 'printenv'
        // echo "${password_USR}"
        // echo "${password_PSW}"
        // sh 'svn co svn://47.96.1.255/ppgame/app/STApp/iOS/ShuTiao/trunk workspace --username ${password_USR} --password ${password_PSW}'
      }
    }
    stage('Build') {
      steps {
          echo 'Build'
      }
    }
    stage('Deploy') {
      steps {
          echo 'Deploy'
      }
    }
  }
  post {
    always {
        echo '加油！ :)'
    }
    success {
      echo '恭喜，构建成功！ :)'
    }
    unstable {
      echo '不稳定啊，兄弟！ :/'
    }
    failure {
      echo '哇哦，构建失败！ :('
    }
    changed {
      echo '小伙子，有点变化呐 ...'
    }
  }
}