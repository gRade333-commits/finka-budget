/**
 * FINKA Budget System — Shared Navigation & Utilities
 * Automatically injects top navigation bar, toast notifications,
 * and keyboard shortcuts into every page.
 */
(function () {
    "use strict";

    /* ── Page Registry ─────────────────────────────────────────── */
    var SECTIONS = {
        rb: {
            label: "Республиканский бюджет",
            short: "РБ",
            items: [
                {
                    href: "rb-svod.html",
                    title: "Свод расходов 2026-2028",
                    key: "rb_svod",
                },
                {
                    href: "rb-svodnaya.html",
                    title: "Сводная общая 2026",
                    key: "rb_svodnaya",
                },
                {
                    href: "rb-income.html",
                    title: "Доходы РБ",
                    key: "rb_income",
                },
                {
                    href: "rb-fzp.html",
                    title: "Фонд заработной платы",
                    key: "rb_fzp",
                },
                {
                    href: "fot-almaty.html",
                    title: "Свод ФОТ Алматы",
                    key: "fot",
                },
                {
                    href: "rb-kalkulyacia.html",
                    title: "Калькуляция расходов",
                    key: "rb_kalkulyacia",
                },
                {
                    href: "rb-plan-komandir.html",
                    title: "План командировок РК",
                    key: "rb_plan_komandir",
                },
                {
                    href: "plan-fact.html",
                    title: "План-Факт РБ",
                    key: "plan_fact_rb",
                },
            ],
        },
        pu: {
            label: "Подушевое финансирование",
            short: "ПУ",
            items: [
                {
                    href: "pu-svod-2026.html",
                    title: "Свод ПУ 2026",
                    key: "pu_svod_2026",
                },
                {
                    href: "pu-ss-dotacia.html",
                    title: "СС Дотация",
                    key: "pu_ss_dotacia",
                },
                {
                    href: "pu-ss-almaty.html",
                    title: "СС Алматы",
                    key: "pu_ss_almaty",
                },
                {
                    href: "pu-income-pu.html",
                    title: "Доходы ПУ",
                    key: "pu_income_pu",
                },
                {
                    href: "pu-income-dt.html",
                    title: "Доходы ДТ",
                    key: "pu_income_dt",
                },
                {
                    href: "pu-income-dop.html",
                    title: "Доходы ДОП",
                    key: "pu_income_dop",
                },
                {
                    href: "pu-fot-almaty.html",
                    title: "ФОТ Алматы",
                    key: "pu_fot_almaty",
                },
                {
                    href: "pu-grafik-almaty.html",
                    title: "График Алматы",
                    key: "pu_grafik_almaty",
                },
                {
                    href: "pu-kalkulyacia-almaty.html",
                    title: "Калькуляция Алматы",
                    key: "pu_kalkulyacia_almaty",
                },
                {
                    href: "pu-plan-rk.html",
                    title: "План командировок РК",
                    key: "pu_plan_rk",
                },
                {
                    href: "pu-plan-abroad.html",
                    title: "План командировок за рубеж",
                    key: "pu_plan_abroad",
                },
            ],
        },
        util: {
            label: "Утилиты",
            short: "Утилиты",
            items: [
                { href: "import-excel.html", title: "Импорт из Excel" },
                { href: "check-import.html", title: "Проверка импорта" },
                { href: "check-formulas.html", title: "Проверка формул" },
                {
                    href: "fill-all-budgets.html",
                    title: "Заполнить все бюджеты",
                },
                { href: "fill-test-data.html", title: "Тестовые данные РБ" },
                { href: "fill-pu-data.html", title: "Тестовые данные ПУ" },
                { href: "fill-rb-svodnaya.html", title: "Заполнение сводной" },
                {
                    href: "reset-and-refill.html",
                    title: "Сброс и перезаполнение",
                },
                {
                    href: "clear-consolidated-data.html",
                    title: "Очистка данных",
                },
                { href: "diagnose-consolidation.html", title: "Диагностика" },
                { href: "migrate-localStorage.html", title: "Миграция данных" },
            ],
        },
    };

    var currentPage = location.pathname.split("/").pop() || "index.html";
    if (currentPage === "index.html" || currentPage === "") return; // dashboard has its own nav

    /* ── Detect Current Section ────────────────────────────────── */
    var currentSection = null;
    var currentTitle = document.title || "";
    for (var key in SECTIONS) {
        var sec = SECTIONS[key];
        for (var i = 0; i < sec.items.length; i++) {
            if (sec.items[i].href === currentPage) {
                currentSection = key;
                currentTitle = sec.items[i].title;
                break;
            }
        }
        if (currentSection) break;
    }

    /* ── Calculate localStorage Size ───────────────────────────── */
    function getStorageSize() {
        var total = 0;
        try {
            for (var i = 0; i < localStorage.length; i++) {
                var k = localStorage.key(i);
                total += k.length + (localStorage.getItem(k) || "").length;
            }
        } catch (e) {
            /* ignore */
        }
        return ((total * 2) / 1024 / 1024).toFixed(1);
    }

    /* ── Build Navigation HTML ─────────────────────────────────── */
    function buildDropdown(section) {
        var html = "";
        for (var i = 0; i < section.items.length; i++) {
            var item = section.items[i];
            var cls = item.href === currentPage ? ' class="current"' : "";
            html +=
                '<a href="' + item.href + '"' + cls + ">" + item.title + "</a>";
        }
        return html;
    }

    var navHTML =
        "" +
        '<nav class="finka-nav">' +
        '  <div class="finka-nav-inner">' +
        '    <a href="index.html" class="finka-nav-brand">' +
        '      <span class="finka-nav-logo">\u20B8</span>' +
        "      <span>РФМШ Бюджет</span>" +
        "    </a>" +
        '    <div class="finka-nav-links">';

    for (var sKey in SECTIONS) {
        var s = SECTIONS[sKey];
        var activeClass = currentSection === sKey ? " active" : "";
        navHTML +=
            "" +
            '<div class="finka-nav-item' +
            activeClass +
            '">' +
            '  <button class="finka-nav-btn" data-section="' +
            sKey +
            '">' +
            s.short +
            ' <span class="finka-arrow">\u25BE</span>' +
            "  </button>" +
            '  <div class="finka-dropdown">' +
            buildDropdown(s) +
            "  </div>" +
            "</div>";
    }

    navHTML +=
        "" +
        "    </div>" +
        '    <div class="finka-nav-right">' +
        '      <span class="finka-nav-storage">' +
        '        <span class="finka-nav-storage-icon">\uD83D\uDCBE</span>' +
        '        <span id="finkaStorageSize">' +
        getStorageSize() +
        " МБ</span>" +
        "      </span>" +
        '      <button class="finka-nav-mobile-btn" aria-label="Меню">\u2630</button>' +
        "    </div>" +
        "  </div>" +
        "</nav>";

    /* ── Toast Container ───────────────────────────────────────── */
    navHTML += '<div class="finka-toast-container" id="finkaToasts"></div>';

    /* ── Inject into DOM ───────────────────────────────────────── */
    var wrapper = document.createElement("div");
    wrapper.innerHTML = navHTML;
    while (wrapper.firstChild) {
        document.body.insertBefore(
            wrapper.firstChild,
            document.body.firstChild,
        );
    }

    /* ── Dropdown Toggle Handling ──────────────────────────────── */
    var navItems = document.querySelectorAll(".finka-nav-item");

    function closeAll() {
        for (var i = 0; i < navItems.length; i++) {
            navItems[i].classList.remove("open");
        }
    }

    for (var n = 0; n < navItems.length; n++) {
        (function (item) {
            var btn = item.querySelector(".finka-nav-btn");
            btn.addEventListener("click", function (e) {
                e.stopPropagation();
                var wasOpen = item.classList.contains("open");
                closeAll();
                if (!wasOpen) item.classList.add("open");
            });
        })(navItems[n]);
    }

    // Desktop: hover open (after small delay)
    if (window.matchMedia("(min-width: 901px)").matches) {
        for (var h = 0; h < navItems.length; h++) {
            (function (item) {
                var timer;
                item.addEventListener("mouseenter", function () {
                    clearTimeout(timer);
                    closeAll();
                    item.classList.add("open");
                });
                item.addEventListener("mouseleave", function () {
                    timer = setTimeout(function () {
                        item.classList.remove("open");
                    }, 150);
                });
            })(navItems[h]);
        }
    }

    // Close on outside click
    document.addEventListener("click", function () {
        closeAll();
    });

    // Mobile hamburger toggle
    var mobileBtn = document.querySelector(".finka-nav-mobile-btn");
    if (mobileBtn) {
        mobileBtn.addEventListener("click", function (e) {
            e.stopPropagation();
            var nav = document.querySelector(".finka-nav");
            nav.classList.toggle("open");
        });
    }

    /* ── Toast Notification System ─────────────────────────────── */
    var TOAST_ICONS = {
        success: "\u2714",
        error: "\u2718",
        warning: "\u26A0",
        info: "\u2139",
    };

    window.finkaToast = function (message, type) {
        type = type || "info";
        var container = document.getElementById("finkaToasts");
        if (!container) return;

        var toast = document.createElement("div");
        toast.className = "finka-toast " + type;
        toast.innerHTML =
            '<span class="finka-toast-icon">' +
            (TOAST_ICONS[type] || "") +
            "</span>" +
            "<span>" +
            message +
            "</span>";
        container.appendChild(toast);

        setTimeout(function () {
            toast.classList.add("removing");
            setTimeout(function () {
                if (toast.parentNode) toast.parentNode.removeChild(toast);
            }, 200);
        }, 3000);
    };

    /* ── Keyboard Shortcut: Ctrl+S ─────────────────────────────── */
    document.addEventListener("keydown", function (e) {
        if ((e.ctrlKey || e.metaKey) && e.key === "s") {
            e.preventDefault();
            if (typeof window.saveData === "function") {
                window.saveData();
                window.finkaToast("Данные сохранены", "success");
            } else {
                window.finkaToast("На этой странице нечего сохранять", "info");
            }
        }
    });

    /* ── Update Storage Size Periodically ──────────────────────── */
    setInterval(function () {
        var el = document.getElementById("finkaStorageSize");
        if (el) el.textContent = getStorageSize() + " МБ";
    }, 10000);
})();
