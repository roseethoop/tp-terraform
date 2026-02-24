pipeline {
  agent any

parameters {
  string(name: 'CLIENT', defaultValue: 'client1', description: 'Nom du client')
  choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Environnement')
}

  options { timestamps() }

  stages {
    stage('Afficher choix') {
      steps {
        echo "Environnement sélectionné : ${params.ENVIRONMENT}"
      }
    }

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
  steps {
    sh """
      terraform init -input=false -reconfigure \
      -backend-config="key=client1-${params.ENVIRONMENT}.tfstate"
    """
  }
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
        post {
            always {
                cleanWs()
            }
        }
      }
    }
  }
}