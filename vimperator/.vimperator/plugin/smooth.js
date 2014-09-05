
let self = liberator.plugins.smooziee = (function(){

    var scroll_amount = liberator.globalVariables.smooth_scroll_amount || '30';

    mappings.addUserMap(
        [modes.NORMAL],
        ["j"],
        "Smooth scroll down",
        function(count){
            multiplier = (count || 1);
            self.smoothScrollBy(getScrollAmount(scroll_amount * multiplier));
        },
        {
            count: true
        }
        );
    mappings.addUserMap(
        [modes.NORMAL],
        ["k"],
        "Smooth scroll up",
        function(count){
            multiplier = (count || 1) * -1;  // negate for reverse scroll
            self.smoothScrollBy(getScrollAmount(scroll_amount * multiplier));
        },
        {
            count: true
        }
        );
    mappings.addUserMap(
        [modes.NORMAL],
        ["<C-d>"],
        "Smooth scroll down",
        function(count){
            mult = (count || 1);
            self.smoothScrollBy(getScrollAmount((screen.height / 4) * mult));
        },
        {
            count: true
        }
        );
    mappings.addUserMap(
        [modes.NORMAL],
        ["<C-u>"],
        "Smooth scroll up",
        function(count){
            mult = (count || 1) * -1;  // negate for reverse scroll
            self.smoothScrollBy(getScrollAmount((screen.height / 4) * mult));
        },
        {
            count: true
        }
        );
    mappings.addUserMap(
        [modes.NORMAL],
        ["<C-f>", "<PageDown>"],
        "Smooth scroll down",
        function(count){
            mult = (count || 1);
            self.smoothScrollBy(getScrollAmount((screen.height / 2) * mult));
        },
        {
            count: true
        }
        );
    mappings.addUserMap(
        [modes.NORMAL],
        ["<C-b>", "<PageUp>"],
        "Smooth scroll up",
        function(count){
            mult = (count || 1) * -1;  // negate for reverse scroll
            self.smoothScrollBy(getScrollAmount((screen.height / 2) * mult));
        },
        {
            count: true
        }
        );

    var next;
    var win;
    var interval;

    var PUBLICS = {
        smoothScrollBy: function(moment) {
            win = Buffer.findScrollableWindow();
            scroll_interval = liberator.globalVariables.smooth_scroll_interval
            interval = window.eval(scroll_interval || '20');
            clearTimeout(next);
            smoothScroll(moment);
        }
    }

    function logBase(x, y) {
        // Logarithm of arbitrary base `x`
        return Math.log(y) / Math.log(x);
    }

    function getScrollAmount(amount) {
        // see recognition of Fibonacci Numbers (here approximation is used)
        // http://en.wikipedia.org/wiki/Fibonacci_number#Recognizing_Fibonacci_numbers
        phi = 1.618033;
        sqrt5 = 2.236067;
        fn = amount;
        if (fn > 0) {
            n = Math.ceil(logBase(phi,
                    (fn * sqrt5 + Math.sqrt(5 * Math.pow(fn, 2) + 4)) / 2));
        } else {
            n = Math.floor(logBase(phi,
                    (fn * sqrt5 + Math.sqrt(5 * Math.pow(fn, 2) + 4)) / 2));
        }
        return window.eval(n);
    }

    function fib(n){
        // see optimized Binet's formula for Fibonacci sequence
        // http://en.wikipedia.org/wiki/Fibonacci_number#Closed_form_expression
        phi = 1.618033;
        sqrt5 = 2.236067;
        return Math.floor((Math.pow(phi, n) / sqrt5) + 0.5)
    }

    function smoothScroll(moment) {
        if (moment > 0) {
            moment = moment - 1;
            win.scrollBy(0, fib(Math.abs(moment)));
        } else {
            moment = moment + 1;
            win.scrollBy(0, -fib(Math.abs(moment)));
        }

        if (moment == 0)
            return;

        next = setTimeout(function() smoothScroll(moment), interval);
    }

    return PUBLICS;
})();
