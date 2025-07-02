# Guide de configuration Docker

Ce guide vous aidera à configurer et à exécuter votre projet dans un conteneur Docker, simulant un environnement Raspberry Pi OS.

## Prérequis
- Docker installé sur votre machine locale. (Si ce n'est pas le cas, suivez les instructions sur le site officiel de Docker.)

## Étapes pour démarrer le projet

1.  **Clonez le projet** (si ce n'est pas déjà fait) :
    ```bash
    git clone <URL_DE_VOTRE_REPO>
    cd rimoo-rasberry
    ```

2.  **Construisez l'image Docker** :
    Assurez-vous d'être à la racine de votre projet (`rimoo-rasberry/`). Exécutez la commande suivante pour construire l'image Docker. Cela peut prendre quelques minutes lors de la première exécution, car Docker doit télécharger l'image de base et installer les dépendances.
    ```bash
    docker build -t rimoo-rasberry-app .
    ```
    *Remarque : `-t rimoo-rasberry-app` donne un nom à votre image, ce qui la rend plus facile à référencer.* 

3.  **Lancez le conteneur Docker** :
    Une fois l'image construite, vous pouvez lancer le conteneur. L'option `-d` exécute le conteneur en arrière-plan, et `-p 3000:3000` mappe le port 3000 du conteneur au port 3000 de votre machine locale (si votre application principale utilise ce port).
    ```bash
    docker run -d -p 3000:3000 --name rimoo-rasberry-container rimoo-rasberry-app
    ```
    *Remarque : `--name rimoo-rasberry-container` donne un nom à votre conteneur, ce qui facilite sa gestion.* 

4.  **Vérifiez que l'application est en cours d'exécution** :
    Vous pouvez vérifier que votre conteneur est en marche et que les processus sont lancés en utilisant la commande suivante. Vous devriez voir `rimoo-rasberry-container` dans la liste des conteneurs actifs.
    ```bash
    docker ps
    ```
    Pour voir les logs de votre application et des services gérés par Supervisor :
    ```bash
    docker logs rimoo-rasberry-container
    ```
    Vous devriez voir les messages de `Main application started.`, `Service 1 started.`, et `Service 2 started.` ainsi que leurs messages de tâches continues.

5.  **Accédez à l'application (si elle est web)** :
    Si votre `app/index.js` expose une interface web (ce qui est le cas avec `express`), vous pouvez y accéder via votre navigateur à l'adresse suivante :
    ```
    http://localhost:3000
    ```

## Gestion du conteneur

*   **Pour arrêter le conteneur** :
    ```bash
    docker stop rimoo-rasberry-container
    ```

*   **Pour démarrer un conteneur arrêté** :
    ```bash
    docker start rimoo-rasberry-container
    ```

*   **Pour supprimer le conteneur (arrêtez-le d'abord)** :
    ```bash
    docker rm rimoo-rasberry-container
    ```

*   **Pour supprimer l'image Docker (supprimez d'abord tous les conteneurs basés sur cette image)** :
    ```bash
    docker rmi rimoo-rasberry-app
    ```

## Développement avec VS Code (Remote - Containers)

Pour une expérience de développement optimale, vous pouvez utiliser l'extension **Remote - Containers** de Visual Studio Code. Cela vous permet de travailler directement dans le conteneur Docker comme si c'était votre environnement local.

1.  **Installez l'extension** `Remote - Containers` dans VS Code.
2.  Dans VS Code, ouvrez la **Palette de commandes** (Ctrl+Shift+P ou Cmd+Shift+P).
3.  Tapez et sélectionnez `Remote-Containers: Attach to Running Container...`.
4.  Choisissez `rimoo-rasberry-container` dans la liste.

VS Code s'ouvrira dans un nouvel environnement où vous pourrez modifier les fichiers, exécuter des commandes dans le terminal intégré et déboguer votre application, le tout à l'intérieur du conteneur.

## Personnalisation des services

*   **Ajouter ou modifier des processus** :
    Éditez le fichier `docker/supervisord.conf` pour ajouter, modifier ou supprimer des programmes que Supervisor doit gérer. Assurez-vous que le `command` pointe vers l'exécutable ou le script correct de votre service, et que le `directory` est bien défini par rapport à la racine de votre application dans le conteneur (`/app`).

*   **Modifier le Dockerfile** :
    Si vous avez besoin d'installer de nouvelles dépendances système, de changer la version de Node.js/Python, ou d'apporter des modifications à l'environnement de construction, modifiez le `docker/Dockerfile` et reconstruisez l'image Docker. 