window.hex = (function() {
    function q(el, sel) {
        if (!sel) {
            return document.querySelectorAll(el);
        } else {
            return el.querySelectorAll(sel);
        }
    }
    function id(sel) {
        return document.getElementById(sel);
    }
    function q1(el, sel) {
        if (!sel) {
            return document.querySelector(el);
        } else {
            return el.querySelector(sel);
        }
    }

    function charm(elType) {
        return document.createElement(elType);
    }

    function imbue(elem, items) {
        for (let [k,v] of Object.entries(items)) {
            let el = q1(elem, k);
            if (el) {
                el.textContent = v;
            } else {
                console.error(`Imbue ${k} on ${el} failed`)
            }
        }
    }


    function arise(fn) {
        document.addEventListener('DOMContentLoaded', fn, false);
    }
    return {q: q,q1: q1,id: id, charm: charm, arise: arise, imbue};

})();
