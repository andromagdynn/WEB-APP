<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Coupon - EcomCaffe</title>
    <!-- Inclusione di Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Inclusione di Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .navbar { background-color: #343a40; }
        .navbar-brand { color: white !important; font-size: 1.8rem; font-weight: bold; }
        .nav-link { color: white !important; }
        .dropdown-menu { background-color: white; }
        .dropdown-item { color: #343a40; }
        .form-container { margin-top: 30px; }
    </style>
</head>
<body>
<!-- Barra di navigazione per l'area amministrativa -->
<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="/admin">EcomCaffe - Pannello Admin</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
    </div>
</nav>

<div class="container form-container">
    <!-- Sezione a fisarmonica per la gestione dei coupon -->
    <div class="accordion" id="couponAccordion">
        <!-- Pannello per l'inserimento di un nuovo coupon -->
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingAddCoupon">
                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseAddCoupon" aria-expanded="true" aria-controls="collapseAddCoupon">
                    Aggiungi Nuovo Coupon
                </button>
            </h2>
            <div id="collapseAddCoupon" class="accordion-collapse collapse show" aria-labelledby="headingAddCoupon" data-bs-parent="#couponAccordion">
                <div class="accordion-body">
                    <form id="couponForm">
                        <div class="mb-3">
                            <label for="codice" class="form-label">Codice</label>
                            <input type="text" class="form-control" id="codice" name="codice" required>
                        </div>
                        <div class="mb-3">
                            <label for="sconto" class="form-label">Sconto (%)</label>
                            <input type="number" class="form-control" id="sconto" name="sconto" step="0.01" min="0" max="50" required>
                        </div>
                        <div class="mb-3">
                            <label for="dataScadenza" class="form-label">Data Scadenza</label>
                            <input type="date" class="form-control" id="dataScadenza" name="dataScadenza" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Aggiungi Coupon</button>
                    </form>
                    <div id="couponMessage" class="mt-3"></div>
                </div>
            </div>
        </div>
        <!-- Pannello per la visualizzazione dei coupon esistenti -->
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingExistingCoupons">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseExistingCoupons" aria-expanded="false" aria-controls="collapseExistingCoupons">
                    Coupon Esistenti
                </button>
            </h2>
            <div id="collapseExistingCoupons" class="accordion-collapse collapse" aria-labelledby="headingExistingCoupons" data-bs-parent="#couponAccordion">
                <div class="accordion-body">
                    <c:forEach var="coupon" items="${coupons}" varStatus="status">
                        <div class="card mb-3">
                            <div class="card-header">
                                Codice: ${coupon.codice}
                            </div>
                            <div class="card-body">
                                <p><strong>Sconto:</strong> ${coupon.sconto}%</p>
                                <p><strong>Data Scadenza:</strong> ${coupon.dataScadenza}</p>
                                <p>
                                    <strong>Usato:</strong>
                                    <c:choose>
                                        <c:when test="${coupon.usato eq true}">Si</c:when>
                                        <c:otherwise>No</c:otherwise>
                                    </c:choose>
                                </p>
                                <p>
                                    <strong>Utente ID:</strong>
                                    <c:choose>
                                        <c:when test="${coupon.utente != null}">${coupon.utente.id}</c:when>
                                        <c:otherwise>Nessuno</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Inclusione di jQuery e Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Gestione dell'invio del modulo per l'aggiunta di un coupon
    $(document).ready(function(){
        $("#couponForm").submit(function(event){
            event.preventDefault();
            var formData = $(this).serialize();
            $.post("/admin/coupon/aggiungi", formData, function(response){
                if(response.status === "success"){
                    $("#couponMessage").html('<div class="alert alert-success">'+response.message+'</div>');
                    // Ricarica la pagina per aggiornare l'elenco dei coupon
                    location.reload();
                } else {
                    $("#couponMessage").html('<div class="alert alert-danger">'+response.message+'</div>');
                }
            });
        });
    });
</script>
</body>
</html>
