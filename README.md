### Documentation pour le Projet Site Web Playground

### Introduction

Ce projet vise à déployer une application PHP Playground  (my-php-app)  qui apres un click fournie les credentiels  pour utiliser les services prometheus et grafana  à l’utilisateur.  

Cela tourne dans un cluster kubernetes qui expose les services de monitoring Prometheus et Grafana, via l'accès via des tunnels Ngrok. Le déploiement implique l'utilisation de plusieurs fichiers de configuration Kubernetes pour les déploiements et services, ainsi que l'intégration de scripts PHP pour automatiser la création d'utilisateurs dans Grafana.

### Fichiers de Configuration Utilisés

1. **php-configmap.yaml**
2. **php-deployment.yaml**
3. **php-service.yaml**
4. **web-content-configmap.yaml**
5. **grafana-deployment.yaml**
6. **grafana-service.yaml**
7. **prometheus-deployment.yaml**
8. **prometheus-service.yaml**
9. **ngrok-config.yaml**

### Étapes de Déploiement

### 1. Déploiement de l'Application PHP

Les fichiers `php-configmap.yaml`, `php-deployment.yaml`, `php-service.yaml`, et `web-content-configmap.yaml` sont utilisés pour configurer et déployer l'application PHP.

- **php-configmap.yaml** : Définit les configurations pour l'application PHP.
- **php-deployment.yaml** : Déploie l'application PHP dans le cluster Kubernetes.
- **php-service.yaml** : Expose l'application PHP comme un service dans le cluster.

### 2. Déploiement de Prometheus et Grafana

Les fichiers de configuration `prometheus-deployment.yaml`, `prometheus-service.yaml`, `grafana-deployment.yaml` et `grafana-service.yaml` sont utilisés pour déployer et exposer Prometheus et Grafana.

### 3. Exposition des Services avec Ngrok

Ngrok est utilisé pour exposer les services en local et sur Internet via des tunnels sécurisés.

### Commandes Kubernetes Utiles

- **Déploiement des ressources**:
    
    ```
    shCopier le code
    kubectl apply -f prometheus-deployment.yaml
    kubectl apply -f prometheus-service.yaml
    kubectl apply -f grafana-deployment.yaml
    kubectl apply -f grafana-service.yaml
    kubectl apply -f web-content-configmap.yaml
    kubectl apply -f php-deployment.yaml
    kubectl apply -f php-service.yaml
    
    ```
    
- **Port-forwarding des services pour accès local**:
    
    ```
    shCopier le code
    kubectl port-forward -n default svc/prometheus-server 9090
    kubectl port-forward -n default svc/my-php-app 8082
    kubectl port-forward -n default svc/grafana 3000
    
    ```
    
- **Liste de toutes les ressources dans tous les namespaces**:
    
    ```
    shCopier le code
    kubectl get all --all-namespaces
    
    ```
    
- **Accéder à une ressource en bash**:
    
    ```
    shCopier le code
    kubectl exec -it <nom_de_la_ressource> -- /bin/bash
    
    ```
    
- **Suppression d'un pod spécifique**:
    
    ```
    shCopier le code
    kubectl delete pod -n <nom_du_namespace> <nom_de_la_ressource>
    
    ```
    
- **Copier un fichier depuis un pod**:
    
    ```
    shCopier le code
    kubectl cp <nom_de_la_ressource>:/etc/grafana/grafana.ini ./grafana.ini
    
    ```
    
- **Afficher les logs d'une ressource**:
    
    ```
    shCopier le code
    kubectl logs <nom_de_la_ressource> | grep error
    
    ```
    

### Configuration Ngrok

Le fichier de configuration Ngrok (`ngrok-config.yaml`) permet d'exposer les services PHP, Prometheus et Grafana sur Internet. Le contenu typique est le suivant :

```yaml
yamlCopier le code
version: "2"
authtoken: <votre_authtoken>
web_addr: localhost:4040
tunnels:
  prometheus:
    addr: 9090
    proto: http
  grafana:
    addr: 3000
    proto: http
  my-php-app:
    addr: 8082
    proto: http

```

### Script PHP pour Communication avec Grafana

Le script PHP suivant est utilisé pour créer des utilisateurs dans Grafana :

```php
phpCopier le code
<?php
    // Variables
    $grafanaUrl = "https://<votre_ngrok_url>";
    $adminUser = "admin";
    $adminPassword = "admin";

    // Générer un nom d'utilisateur aléatoire
    $username = "user" . time(); // Utilisation de time() pour générer un nom unique

    // Générer un mot de passe aléatoire
    $password = "password";

    // Données à envoyer sous forme JSON
    $postData = array(
        "name" => $username,
        "email" => $username . "@example.com",
        "login" => $username,
        "password" => $password,
        "OrgId" => 1
    );

    $postDataJson = json_encode($postData);

    // Configuration de la requête cURL
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $grafanaUrl . "/api/admin/users");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postDataJson);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        "Content-Type: application/json",
        "Content-Length: " . strlen($postDataJson))
    );
    curl_setopt($ch, CURLOPT_USERPWD, "$adminUser:$adminPassword");

    // Exécution de la requête
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    // Fermeture de la session cURL
    curl_close($ch);

    // Vérification de la réponse de l'API
    if ($httpCode == 200 || $httpCode == 201) {
        echo "Utilisateur créé avec succès : $username\n";
        echo "Mot de passe créé avec succès : $password\n";
    } else {
        echo "Erreur lors de la création de l'utilisateur : $response\n";
    }
?>

```

Ce script envoie une requête POST à Grafana pour créer un nouvel utilisateur avec un nom et un mot de passe aléatoires.

---

## Dossier

---

![Capture d’écran (72).png](https://raw.githubusercontent.com/Agb242/playground/main/images/Capture%20d%E2%80%99%C3%A9cran%20(72).png?token=GHSAT0AAAAAACSZEVZMVIPAJMPNUXZUXOFSZTMJBDA)

![Capture d’écran (72).png](https://raw.githubusercontent.com/Agb242/playground/main/images/Capture%20d%E2%80%99%C3%A9cran%20(72).png?token=GHSAT0AAAAAACSZEVZMVIPAJMPNUXZUXOFSZTMJBDA)
## Lessons Learned

What did you learn while building this project? What challenges did you face and how did you overcome them?

### Documentation pour le Projet Site Web Playground

### Introduction

Ce projet vise à déployer une application PHP Playground  (my-php-app)  qui apres un click fournie les credentiels  pour utiliser les services prometheus et grafana  à l’utilisateur.  

Cela tourne dans un cluster kubernetes qui expose les services de monitoring Prometheus et Grafana, via l'accès via des tunnels Ngrok. Le déploiement implique l'utilisation de plusieurs fichiers de configuration Kubernetes pour les déploiements et services, ainsi que l'intégration de scripts PHP pour automatiser la création d'utilisateurs dans Grafana.

### Fichiers de Configuration Utilisés

1. **php-configmap.yaml**
2. **php-deployment.yaml**
3. **php-service.yaml**
4. **web-content-configmap.yaml**
5. **grafana-deployment.yaml**
6. **grafana-service.yaml**
7. **prometheus-deployment.yaml**
8. **prometheus-service.yaml**
9. **ngrok-config.yaml**

### Étapes de Déploiement

### 1. Déploiement de l'Application PHP

Les fichiers `php-configmap.yaml`, `php-deployment.yaml`, `php-service.yaml`, et `web-content-configmap.yaml` sont utilisés pour configurer et déployer l'application PHP.

- **php-configmap.yaml** : Définit les configurations pour l'application PHP.
- **php-deployment.yaml** : Déploie l'application PHP dans le cluster Kubernetes.
- **php-service.yaml** : Expose l'application PHP comme un service dans le cluster.

### 2. Déploiement de Prometheus et Grafana

Les fichiers de configuration `prometheus-deployment.yaml`, `prometheus-service.yaml`, `grafana-deployment.yaml` et `grafana-service.yaml` sont utilisés pour déployer et exposer Prometheus et Grafana.

### 3. Exposition des Services avec Ngrok

Ngrok est utilisé pour exposer les services en local et sur Internet via des tunnels sécurisés.

### Commandes Kubernetes Utiles

- **Déploiement des ressources**:
    
    ```
    shCopier le code
    kubectl apply -f prometheus-deployment.yaml
    kubectl apply -f prometheus-service.yaml
    kubectl apply -f grafana-deployment.yaml
    kubectl apply -f grafana-service.yaml
    kubectl apply -f web-content-configmap.yaml
    kubectl apply -f php-deployment.yaml
    kubectl apply -f php-service.yaml
    
    ```
    
- **Port-forwarding des services pour accès local**:
    
    ```
    shCopier le code
    kubectl port-forward -n default svc/prometheus-server 9090
    kubectl port-forward -n default svc/my-php-app 8082
    kubectl port-forward -n default svc/grafana 3000
    
    ```
    
- **Liste de toutes les ressources dans tous les namespaces**:
    
    ```
    shCopier le code
    kubectl get all --all-namespaces
    
    ```
    
- **Accéder à une ressource en bash**:
    
    ```
    shCopier le code
    kubectl exec -it <nom_de_la_ressource> -- /bin/bash
    
    ```
    
- **Suppression d'un pod spécifique**:
    
    ```
    shCopier le code
    kubectl delete pod -n <nom_du_namespace> <nom_de_la_ressource>
    
    ```
    
- **Copier un fichier depuis un pod**:
    
    ```
    shCopier le code
    kubectl cp <nom_de_la_ressource>:/etc/grafana/grafana.ini ./grafana.ini
    
    ```
    
- **Afficher les logs d'une ressource**:
    
    ```
    shCopier le code
    kubectl logs <nom_de_la_ressource> | grep error
    
    ```
    

### Configuration Ngrok

Le fichier de configuration Ngrok (`ngrok-config.yaml`) permet d'exposer les services PHP, Prometheus et Grafana sur Internet. Le contenu typique est le suivant :

```yaml
yamlCopier le code
version: "2"
authtoken: <votre_authtoken>
web_addr: localhost:4040
tunnels:
  prometheus:
    addr: 9090
    proto: http
  grafana:
    addr: 3000
    proto: http
  my-php-app:
    addr: 8082
    proto: http

```

### Script PHP pour Communication avec Grafana

Le script PHP suivant est utilisé pour créer des utilisateurs dans Grafana :

```php
phpCopier le code
<?php
    // Variables
    $grafanaUrl = "https://<votre_ngrok_url>";
    $adminUser = "admin";
    $adminPassword = "admin";

    // Générer un nom d'utilisateur aléatoire
    $username = "user" . time(); // Utilisation de time() pour générer un nom unique

    // Générer un mot de passe aléatoire
    $password = "password";

    // Données à envoyer sous forme JSON
    $postData = array(
        "name" => $username,
        "email" => $username . "@example.com",
        "login" => $username,
        "password" => $password,
        "OrgId" => 1
    );

    $postDataJson = json_encode($postData);

    // Configuration de la requête cURL
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $grafanaUrl . "/api/admin/users");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postDataJson);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
        "Content-Type: application/json",
        "Content-Length: " . strlen($postDataJson))
    );
    curl_setopt($ch, CURLOPT_USERPWD, "$adminUser:$adminPassword");

    // Exécution de la requête
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

    // Fermeture de la session cURL
    curl_close($ch);

    // Vérification de la réponse de l'API
    if ($httpCode == 200 || $httpCode == 201) {
        echo "Utilisateur créé avec succès : $username\n";
        echo "Mot de passe créé avec succès : $password\n";
    } else {
        echo "Erreur lors de la création de l'utilisateur : $response\n";
    }
?>

```

Ce script envoie une requête POST à Grafana pour créer un nouvel utilisateur avec un nom et un mot de passe aléatoires.

---

## Dossier

---



![apres click sur bouton](https://raw.githubusercontent.com/Agb242/playground/main/images/Capture%20d%E2%80%99%C3%A9cran%20(75).png?token=GHSAT0AAAAAACSZEVZMZT77PH7VSSWWKVBCZTMJEZQ)

![Connexiion](https://raw.githubusercontent.com/Agb242/playground/main/images/Capture%20d%E2%80%99%C3%A9cran%20(85).png?token=GHSAT0AAAAAACSZEVZN4ZNJL4QOJUJNEG3WZTMJGNQ)

![Connexiion](https://raw.githubusercontent.com/Agb242/playground/main/images/Capture%20d%E2%80%99%C3%A9cran%20(86).png?token=GHSAT0AAAAAACSZEVZNTKHSL5UQZ5XNVUO6ZTMJIQA)

