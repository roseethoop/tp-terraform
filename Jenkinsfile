pipeline {
  agent any
  options { timestamps() }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Terraform version') {
      steps { sh 'terraform version' }
    }

    stage('Fmt') {
      steps { sh 'terraform fmt -check -recursive' }
    }

    stage('Init') {
      steps { sh 'terraform init -input=false' }
    }

    stage('Validate') {
      steps { sh 'terraform validate' }
    }

    stage('Plan') {
      steps { sh 'terraform plan -out=tfplan -input=false' }
    }

    stage('Apply') {
      when { branch 'main' }
      steps {
        input message: 'Appliquer le plan Terraform sur AWS ?'
        sh 'terraform apply -input=false tfplan'
      }
    }
  }
}
