# CRCHUM-CITADEL/nextflow-sante-precision (English)

(Traduction en francais suit)

## Clone
To run this pipeline, you first need to git clone this repository and enter the directory:
```
git clone https://github.com/CRCHUM-CITADEL/nextflow-sante-precision.git && cd
```

> [!NOTE]
> For all containers we are using Apptainer because of it's compatibility with HPC environments.
> Find how to install here: https://apptainer.org/docs/admin/main/installation.html

## Pull nextflow container image
In order to run nextflow with the exact software used to build the pipeline, pull the container image hosted on CITADEL's organisational Github (or if not in a member in crchum-citadel GitHub, ask for the location of the locally-stored .sif file.)
```
apptainer pull --dir containers/ oras://ghcr.io/crchum-citadel/sdp-nextflow:25.04.7
```

> [!NOTE]
> in order to pull from the github repository, you need to be have your credentials stored in your environment, and be a member of the crchum-citadel GitHub.
> You will need to first create a <a href="https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens" target="_blank">PAT token with appropriate permissions</a>  
> To authenticate:
> `apptainer registry login --username <username> oras://ghcr.io`
> You will be prompted for your PAT token.


## Run nextflow via apptainer

Structure your command as such:
```
apptainer exec containers/sdp-nextflow_<version>.sif nextflow <command>
```

To get the version:
```
apptainer exec containers/sdp-nextflow_v25.04.7.sif nextflow -v
```

To run the pipeline test (using minimal data):
```
apptainer exec containers/sdp-nextflow_v25.04.7.sif nextflow run main.nf -profile test,apptainer
```

> [!NOTE]
> Always run the pipeline with atleast the apptainer profile option, or else it won't work. (E.g. -profile apptainer)


## NF-Core functionality

This pipeline was build from a nf-core template. You may want to use some nf-core CLI functionality.

According to the documentation, you can run directly from the container:
```
apptainer exec \
    --bind $(pwd):$(pwd) \
    --pwd $(pwd) \
    docker://nfcore/tools:3.3.2 \
    nf-core pipelines list
```

> [!NOTE]
> You will likely want to create an alias in your ~/.bashrc file. In this file, include:
> `alias nf-core="apptainer exec --bind $(pwd):$(pwd) --pwd $(pwd) docker://nfcore/tools:3.3.2 nf-core"`
> (Don't forget to source and change versions when there's an update!)



> [!NOTE]
> If you're looking to update the container registry, you need to:
> 1. Build the image
> `apptainer build <new_sif_file>.sif <def_file>.def`
> 2. Push the image:
> `apptainer push <new_sif_file>.sif oras://ghcr.io/crchum-citadel/<name>:<version>`


## For developpers:

> [!IMPORTANT]
> Always make changes in the dev branch of the repository. To merge changes to the main branch, create a pull request and make sure all tests pass.
> Alternatively, create an issue in the GitHub repository.

### Other functionalities: 

To run nf-test:
```
apptainer exec containers/nextflow-citadel_v25.04.7.sif nf-test test --profile apptainer
```

To run pre-commit (to check linting before pull request):
```
apptainer exec containers/nextflow-citadel_v25.04.7.sif pre-commit run .
```

# CRCHUM-CITADEL/nextflow-sante-precision (Francais)

Documentation de démarrage (Traduction en français)

## Cloner le dépôt
Pour exécuter ce pipeline, vous devez d'abord cloner ce dépôt Git et entrer dans le répertoire :
```
git clone https://github.com/CRCHUM-CITADEL/nextflow-sante-precision.git && cd
```

> [!NOTE]
> Pour tous les conteneurs, nous utilisons Apptainer en raison de sa compatibilité avec les environnements HPC.
> Trouvez comment l’installer ici : https://apptainer.org/docs/admin/main/installation.html

## Télécharger l’image du conteneur Nextflow
Afin d'exécuter Nextflow avec les logiciels exacts utilisés pour construire le pipeline, téléchargez l'image du conteneur hébergée sur le GitHub organisationnel de CITADEL (ou si vous n'êtes pas membre du GitHub crchum-citadel, demandez l'emplacement du fichier .sif stocké localement).
```
apptainer pull --dir containers/ oras://ghcr.io/crchum-citadel/sdp-nextflow:25.04.7
```

> [!NOTE]
> Pour télécharger depuis le dépôt GitHub, vous devez avoir vos identifiants enregistrés dans votre environnement et être membre du GitHub crchum-citadel.
> Vous devrez d'abord créer un <a href="https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens" target="_blank">jeton PAT avec les permissions appropriées</a>  
> Pour vous authentifier :
> `apptainer registry login --username <nom_utilisateur> oras://ghcr.io`
> Vous serez invité à entrer votre jeton PAT.

## Exécuter Nextflow via Apptainer

Structurez votre commande comme suit :
```
apptainer exec containers/sdp-nextflow_<version>.sif nextflow <commande>
```

Pour obtenir la version :
```
apptainer exec containers/sdp-nextflow_v25.04.7.sif nextflow -v
```

Pour exécuter le test du pipeline (avec des données minimales) :
```
apptainer exec containers/sdp-nextflow_v25.04.7.sif nextflow run main.nf -profile test,apptainer
```

> [!NOTE]
> Exécutez toujours le pipeline avec au moins l’option de profil `apptainer`, sinon cela ne fonctionnera pas. (Ex. : `-profile apptainer`)

## Fonctionnalité NF-Core

Ce pipeline a été construit à partir d’un modèle nf-core. Vous pouvez vouloir utiliser certaines fonctionnalités de la CLI nf-core.

Selon la documentation, vous pouvez l’exécuter directement depuis le conteneur :
```
apptainer exec     --bind $(pwd):$(pwd)     --pwd $(pwd)     docker://nfcore/tools:3.3.2     nf-core pipelines list
```

> [!NOTE]
> Vous voudrez probablement créer un alias dans votre fichier `~/.bashrc`. Dans ce fichier, incluez :
> `alias nf-core="apptainer exec --bind $(pwd):$(pwd) --pwd $(pwd) docker://nfcore/tools:3.3.2 nf-core"`
> (N’oubliez pas de faire un `source` et de changer la version lors des mises à jour !)

> [!NOTE]
> Si vous souhaitez mettre à jour le registre de conteneurs, vous devez :
> 1. Construire l’image :
> `apptainer build <nouveau_fichier_sif>.sif <fichier_def>.def`
> 2. Pousser l’image :
> `apptainer push <nouveau_fichier_sif>.sif oras://ghcr.io/crchum-citadel/<nom>:<version>`

## Pour les développeurs :

> [!IMPORTANT]
> Faites toujours les modifications dans la branche `dev` du dépôt. Pour fusionner les changements dans la branche `main`, créez une pull request et assurez-vous que tous les tests passent.
> Vous pouvez aussi créer une issue dans le dépôt GitHub.

### Autres fonctionnalités :

Pour exécuter `nf-test` :
```
apptainer exec containers/nextflow-citadel_v25.04.7.sif nf-test test --profile apptainer
```

Pour exécuter `pre-commit` (pour vérifier le linting avant une pull request) :
```
apptainer exec containers/nextflow-citadel_v25.04.7.sif pre-commit run .
```
