$(document).ready(function () {
    window.addEventListener('message', function (event) {
        let data = event.data;

        if (data.action === "openReportForm") {
            $("#report-form").fadeIn(200);
            $("#admin-panel").hide();
            $("#report-reason").val("").focus();
        } else if (data.action === "openAdminPanel") {
            $("#admin-panel").fadeIn(200);
            $("#report-form").hide();
            loadReports(data.reports);
        } else if (data.action === "updateReports") {
            if ($("#admin-panel").is(":visible")) {
                loadReports(data.reports);
            }
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // ESC key
            closeUI();
        }
    };

    $("#close-btn, #admin-close-btn").click(function () {
        closeUI();
    });

    $("#submit-btn").click(function () {
        let reason = $("#report-reason").val();
        if (reason.length > 2) {
            $.post('https://admin_reports/submitReport', JSON.stringify({
                reason: reason
            }));
            closeUI();
        }
    });
});

function closeUI() {
    $("#report-form").fadeOut(200);
    $("#admin-panel").fadeOut(200);
    $.post('https://admin_reports/closeUI', JSON.stringify({}));
}

function loadReports(reports) {
    let list = $("#report-list");
    list.empty();

    if (!reports || reports.length === 0) {
        list.html('<div class="empty-state">No active reports. Good job! 🎉</div>');
        return;
    }

    // Reports are expected to be an array of objects
    reports.forEach(report => {
        let card = `
            <div class="report-card">
                <div class="report-header">
                    <div>
                        <span class="player-info">${report.name}</span>
                        <span class="player-id">ID: ${report.source}</span>
                    </div>
                    <span class="time-ago">${report.time}</span>
                </div>
                <div class="report-reason">
                    ${report.reason}
                </div>
                <div class="report-actions">
                    <button class="btn btn-secondary btn-sm" onclick="tpToPlayer(${report.source})">Teleport</button>
                    <button class="btn btn-primary btn-sm" onclick="concludeReport(${report.id})">Conclude</button>
                </div>
            </div>
        `;
        list.append(card);
    });
}

window.tpToPlayer = function (targetId) {
    $.post('https://admin_reports/tpToPlayer', JSON.stringify({
        targetId: targetId
    }));
}

window.concludeReport = function (reportId) {
    $.post('https://admin_reports/concludeReport', JSON.stringify({
        reportId: reportId
    }));
}
