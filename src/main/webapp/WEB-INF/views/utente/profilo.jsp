<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Profilo Utente - EcomCaffe</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <!-- Chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body {
      background-color: #f8f9fa;
    }
    /* Navbar unificata */
    .navbar { background-color: #343a40; }
    .navbar-brand { color: white !important; font-size: 1.8rem; font-weight: bold; }
    /* Mantenimento dei link in bianco nella navbar, mentre nel dropdown usiamo colori di default */
    .nav-link { color: white !important; }
    .dropdown-menu { background-color: white; }
    .dropdown-item { color: #343a40; }
    /* Stile dei product card (se necessarie in altre sezioni) */
    .product-card {
      transition: transform 0.3s;
      cursor: pointer;
    }
    .product-card:hover {
      transform: scale(1.05);
    }
    /* Stili per la modale (se necessarie) */
    .modal-header, .modal-body, .modal-footer { text-align: center; }
    .modal-title { font-size: 1.5rem; font-weight: bold; }
  </style>
</head>
<body>

<!-- Navbar identica a quella della home -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="/">EcomCaffe</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav me-3">
        <!-- Icona del carrello -->
        <li class="nav-item">
          <a class="nav-link" href="/carrello">
            <i class="bi bi-cart"></i>
          </a>
        </li>
      </ul>
      <ul class="navbar-nav">
        <c:choose>
          <c:when test="${not empty sessionScope.utente}">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                  ${sessionScope.utente.username}
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <!-- La voce "Profilo" è stata omessa perché siamo già nella pagina Profilo -->
                <li><a class="dropdown-item" href="/wishlist">Wishlist</a></li>
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

<div class="container mt-4">
  <h3>Profilo Utente</h3>

  <!-- Dati Personali -->
  <div class="card">
    <div class="card-body">
      <h5 class="card-title">Dati Personali</h5>
      <p><strong>Username:</strong> ${utente.username}</p>
      <p><strong>Email:</strong> ${utente.email}</p>
      <p><strong>Ruolo:</strong> ${utente.ruolo}</p>
      <p><strong>Stato Account:</strong>
        <span class="badge bg-${utente.stato == 'ATTIVO' ? 'success' : 'danger'}">
          ${utente.stato}
        </span>
      </p>
    </div>
  </div>

  <hr>

  <!-- Statistiche Acquisti -->
  <h4>Statistiche Acquisti</h4>
  <div class="row">
    <div class="col-md-6">
      <div class="card text-white bg-primary mb-3">
        <div class="card-body">
          <h5 class="card-title">Ordini Effettuati</h5>
          <p class="card-text fs-4">${numeroOrdini}</p>
        </div>
      </div>
    </div>
    <div class="col-md-6">
      <div class="card text-white bg-success mb-3">
        <div class="card-body">
          <h5 class="card-title">Spesa Totale</h5>
          <p class="card-text fs-4">${spesaTotale}€</p>
        </div>
      </div>
    </div>
  </div>

  <hr>

  <!-- Andamento Acquisti (Grafico) -->
  <h4>Andamento Acquisti</h4>
  <div style="width: 100%; max-width: 700px; height: 200px; margin: auto;">
    <canvas id="chartOrdini"></canvas>
  </div>

  <hr>

  <!-- Indirizzi di Spedizione -->
  <h4>Indirizzi di Spedizione Utilizzati</h4>
  <c:if test="${empty indirizziUsati}">
    <p class="text-muted">Nessun indirizzo salvato.</p>
  </c:if>
  <ul class="list-group">
    <c:forEach var="indirizzo" items="${indirizziUsati}">
      <li class="list-group-item">${indirizzo}</li>
    </c:forEach>
  </ul>

  <hr>
</div>

<!-- Script per il grafico con Chart.js -->
<script>
  document.addEventListener("DOMContentLoaded", function () {
    // Converte le liste passate dal controller in array JavaScript
    var dateOrdini = [
      <c:forEach var="data" items="${dateOrdini}" varStatus="status">
      "${data}"<c:if test="${!status.last}">,</c:if>
      </c:forEach>
    ];
    var importiOrdini = [
      <c:forEach var="importo" items="${importiOrdini}" varStatus="status">
      ${importo}<c:if test="${!status.last}">,</c:if>
      </c:forEach>
    ];

    let ctx = document.getElementById('chartOrdini').getContext('2d');
    let datiOrdini = {
      labels: dateOrdini,
      datasets: [{
        label: "Spesa (€)",
        data: importiOrdini,
        borderColor: "blue",
        borderWidth: 2,
        fill: false,
        pointRadius: 3,
        tension: 0.2
      }]
    };

    new Chart(ctx, {
      type: 'line',
      data: datiOrdini,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          x: { title: { display: true, text: "Mese" } },
          y: { title: { display: true, text: "Spesa (€)" }, beginAtZero: true }
        },
        plugins: {
          legend: { display: false }
        }
      }
    });
  });
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
