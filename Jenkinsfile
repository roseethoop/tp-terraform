pipeline {
  agent any

  parameters {
    choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Choisir l’environnement')
    booleanParam(name: 'DESTROY', defaultValue: false, description: '⚠️ Détruire l’infrastructure (terraform destroy) ?')
  }

  options { timestamps() }

  stages {
    stage('Afficher choix') {
      steps {
        echo "ENV=${params.ENVIRONMENT} | DESTROY=${params.DESTROY}"
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

    stage('Destroy') {
      when { expression { return params.DESTROY == true } }
      steps {
        input message: "⚠️ Confirme la destruction (ENV=${params.ENVIRONMENT}). Continuer ?"
        sh 'terraform destroy -auto-approve -input=false'
      }
    }

    stage('Apply') {
      when {
        allOf {
          branch 'main'
          expression { return params.DESTROY == false }
        }
      }
      steps {
        input message: "Appliquer le plan Terraform sur AWS ? (ENV=${params.ENVIRONMENT})"
        sh 'terraform apply -input=false tfplan'
      }
    }
  }
}