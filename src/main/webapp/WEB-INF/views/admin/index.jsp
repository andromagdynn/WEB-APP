<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Funzionalità Admin - EcomCaffe</title>
  <!-- Inclusione di Bootstrap 5 per lo styling della pagina -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Inclusione delle icone di Bootstrap -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    /* Impostazioni di base per lo stile della pagina */
    body {
      background-color: #f8f9fa;
    }
    /* Stile della barra di navigazione per l'area admin */
    .navbar {
      background-color: #343a40;
    }
    .navbar-brand {
      color: white !important;
      font-size: 1.8rem;
      font-weight: bold;
    }
    .nav-link {
      color: white !important;
    }
    .dropdown-menu {
      background-color: white;
    }
    .dropdown-item {
      color: #343a40;
    }
    /* Stile dei pulsanti per le funzionalità amministrative */
    .admin-btn {
      margin: 20px;
      font-size: 1.2rem;
      padding: 20px 40px;
    }
  </style>
</head>
<body>
<!-- Barra di navigazione principale per l'area admin -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="/">EcomCaffe - Pannello Admin</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
  </div>
</nav>

<!-- Contenuto centrale della pagina admin -->
<div class="container mt-5 text-center">
  <h1 class="mb-4">Funzionalità Admin</h1>
  <div class="d-flex justify-content-center">
    <!-- Link per accedere alla gestione del catalogo prodotti -->
    <a href="/admin/gestione" class="btn btn-primary admin-btn">Gestione Catalogo</a>
    <!-- Link per accedere alla gestione degli utenti -->
    <a href="/admin/utenti" class="btn btn-secondary admin-btn">Gestione Utenti</a>
    <!-- Link per accedere alla gestione dei coupon -->
    <a href="/admin/coupon" class="btn btn-secondary admin-btn">Gestione Coupon</a>
  </div>
</div>

<!-- Inclusione degli script di Bootstrap per il comportamento dinamico della pagina -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
