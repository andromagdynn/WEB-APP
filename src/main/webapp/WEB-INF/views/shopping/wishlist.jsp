<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Wishlist - EcomCaffe</title>
  <!-- Caricamento di Bootstrap 5 per lo styling della pagina -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Caricamento delle icone di Bootstrap -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    body {
      background-color: #f8f9fa;
    }
    /* Stile per la barra di navigazione */
    .navbar { background-color: #343a40; }
    .navbar-brand { color: white !important; font-size: 1.8rem; font-weight: bold; }
    .nav-link { color: white !important; }
    .dropdown-menu { background-color: white; }
    .dropdown-item { color: #343a40; }
  </style>
</head>
<body>

<!-- Sezione: Header con la navigazione principale -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="/">EcomCaffe</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav me-3">
        <!-- Link al carrello -->
        <li class="nav-item">
          <a class="nav-link" href="/carrello"><i class="bi bi-cart"></i></a>
        </li>
      </ul>
      <ul class="navbar-nav">
        <!-- Menu utente in base all'autenticazione -->
        <c:choose>
          <c:when test="${not empty sessionScope.utente}">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                  ${sessionScope.utente.username}
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" href="/profilo">Profilo</a></li>
                <li><a class="dropdown-item" href="/carrello/storico">Storico</a></li>
                <c:if test="${sessionScope.utente.ruolo eq 'ADMIN'}">
                  <li><a class="dropdown-item" href="/admin">Admin</a></li>
                </c:if>
                <li><a class="dropdown-item" href="/logout">Logout</a></li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="guestDropdown" role="button" data-bs-toggle="dropdown">
                Account
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="guestDropdown">
                <li><a class="dropdown-item" href="/login">Login</a></li>
                <li><a class="dropdown-item" href="/registrati">Registrati</a></li>
              </ul>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<!-- Sezione: Contenuto principale per la visualizzazione della wishlist -->
<div class="container mt-4">
  <h2 class="text-center">❤️ La tua Wishlist</h2>

  <!-- Messaggio informativo se la wishlist è vuota -->
  <c:if test="${empty wishlist}">
    <div class="alert alert-info text-center">
      La tua wishlist è vuota. Esplora i prodotti e aggiungi quelli che ti piacciono!
      <br>
      <a href="/" class="btn btn-primary btn-sm mt-2">Torna alla Home</a>
    </div>
  </c:if>

  <!-- Tabella che visualizza i prodotti presenti nella wishlist -->
  <c:if test="${not empty wishlist}">
    <table class="table">
      <thead>
      <tr>
        <th>Prodotto</th>
        <th>Prezzo</th>
        <th>Azioni</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach var="item" items="${wishlist}">
        <tr>
          <td>${item.prodotto.nome}</td>
          <td>${item.prodotto.prezzo}€</td>
          <td>
            <!-- Form per aggiungere il prodotto al carrello -->
            <form action="/carrello/aggiungi/${item.prodotto.id}" method="post" class="d-inline">
              <input type="hidden" name="quantita" value="1">
              <button type="submit" class="btn btn-success btn-sm">Aggiungi al Carrello</button>
            </form>
            <!-- Form per rimuovere il prodotto dalla wishlist -->
            <form action="/wishlist/rimuovi/${item.prodotto.id}" method="post" class="d-inline">
              <button type="submit" class="btn btn-danger btn-sm">Rimuovi</button>
            </form>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </c:if>
</div>

<!-- Inclusione degli script di Bootstrap per le funzionalità dinamiche -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
