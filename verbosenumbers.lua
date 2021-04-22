local floor = lua.floor


-- verbose english

local words = {
               [0] = "zero",
               [1] = "one",
               [2] = "two",
               [3] = "three",
               [4] = "four",
               [5] = "five",
               [6] = "six",
               [7] = "seven",
               [8] = "eight",
               [9] = "nine",
              [10] = "ten",
              [11] = "eleven",
              [12] = "twelve",
              [13] = "thirteen",
              [14] = "fourteen",
              [15] = "fifteen",
              [16] = "sixteen",
              [17] = "seventeen",
              [18] = "eighteen",
              [19] = "nineteen",
              [20] = "twenty",
              [30] = "thirty",
              [40] = "forty",
              [50] = "fifty",
              [60] = "sixty",
              [70] = "seventy",
              [80] = "eighty",
              [90] = "ninety",
             [100] = "hundred",
            [1000] = "thousand",
         [1000000] = "million",
      [1000000000] = "billion",
   [1000000000000] = "trillion",
}

local function translate(n,connector)
    local w = words[n]
    if w then
        return w
    end
    local t = { }
    local function compose_one(n)
        local w = words[n]
        if w then
            t[#t+1] = w
            return
        end
        local a, b = floor(n/100), n % 100
        if a == 10 then
            t[#t+1] = words[1]
            t[#t+1] = words[1000]
        elseif a > 0 then
            t[#t+1] = words[a]
            t[#t+1] = words[100]
            -- don't say 'nine hundred zero'
            if b == 0 then
                return
            end
        end
        if words[b] then
            t[#t+1] = words[b]
        else
            a, b = floor(b/10), n % 10
            t[#t+1] = words[a*10]
            t[#t+1] = words[b]
        end
    end
    local function compose_two(n,m)
        if n > (m-1) then
            local a, b = floor(n/m), n % m
            if a > 0 then
                compose_one(a)
            end
            t[#t+1] = words[m]
            n = b
        end
        return n
    end
    n = compose_two(n,1000000000000)
    n = compose_two(n,1000000000)
    n = compose_two(n,1000000)
    n = compose_two(n,1000)
    if n > 0 then
        compose_one(n)
    end
    return #t > 0 and concat(t,connector or " ") or tostring(n)
end

data.english = {
    words     = words,
    translate = translate,
}

data.en = data.english

-- verbose spanish (unchecked)

local words = {
               [1] = "uno",
               [2] = "dos",
               [3] = "tres",
               [4] = "cuatro",
               [5] = "cinco",
               [6] = "seis",
               [7] = "siete",
               [8] = "ocho",
               [9] = "nueve",
              [10] = "diez",
              [11] = "once",
              [12] = "doce",
              [13] = "trece",
              [14] = "catorce",
              [15] = "quince",
              [16] = "dieciséis",
              [17] = "diecisiete",
              [18] = "dieciocho",
              [19] = "diecinueve",
              [20] = "veinte",
              [21] = "veintiuno",
              [22] = "veintidós",
              [23] = "veintitrés",
              [24] = "veinticuatro",
              [25] = "veinticinco",
              [26] = "veintiséis",
              [27] = "veintisiete",
              [28] = "veintiocho",
              [29] = "veintinueve",
              [30] = "treinta",
              [40] = "cuarenta",
              [50] = "cincuenta",
              [60] = "sesenta",
              [70] = "setenta",
              [80] = "ochenta",
              [90] = "noventa",
             [100] = "ciento",
             [200] = "doscientos",
             [300] = "trescientos",
             [400] = "cuatrocientos",
             [500] = "quinientos",
             [600] = "seiscientos",
             [700] = "setecientos",
             [800] = "ochocientos",
             [900] = "novecientos",
            [1000] = "mil",
         [1000000] = "millón",
      [1000000000] = "mil millones",
   [1000000000000] = "billón",
}

local function translate(n,connector)
    local w = words[n]
    if w then
        return w
    end
    local t = { }
    local function compose_one(n)
        local w = words[n]
        if w then
            t[#t+1] = w
            return
        end
        -- a, b = hundreds, remainder
        local a, b = floor(n/100), n % 100
        -- one thousand
        if a == 10 then
            t[#t+1] = words[1]
            t[#t+1] = words[1000]
        -- x hundred (n.b. this will not give thirteen hundred because
        -- compose_one(n) is only called after
        -- n = compose(two(n, 1000))
        elseif a > 0 then
            t[#t+1] = words[a*100]
        end
        -- the remainder
        if words[b] then
            t[#t+1] = words[b]
        else
            -- a, b = tens, remainder
            a, b = floor(b/10), n % 10
            t[#t+1] = words[a*10]
            t[#t+1] = "y"
            t[#t+1] = words[b]
        end
    end
    -- compose_two handles x billion, ... x thousand. When 1000 or less is
    -- left, compose_one takes over.
    local function compose_two(n,m)
        if n > (m-1) then
            local a, b = floor(n/m), n % m
            if a > 0 then
                compose_one(a)
            end
            t[#t+1] = words[m]
            n = b
        end
        return n
    end
    n = compose_two(n,1000000000000)
    n = compose_two(n,1000000000)
    n = compose_two(n,1000000)
    n = compose_two(n,1000)
    if n > 0 then
        compose_one(n)
    end
    return #t > 0 and concat(t,connector or " ") or tostring(n)
end

data.spanish = {
    words     = words,
    translate = translate,
}

data.es = data.spanish

-- print(translate(31))
-- print(translate(101))
-- print(translate(199))

-- verbose swedish by Peter Kvillegard

do

    local words = {
            [0] = "noll",
            [1] = "ett",
            [2] = "två",
            [3] = "tre",
            [4] = "fyra",
            [5] = "fem",
            [6] = "sex",
            [7] = "sju",
            [8] = "åtta",
            [9] = "nio",
           [10] = "tio",
           [11] = "elva",
           [12] = "tolv",
           [13] = "tretton",
           [14] = "fjorton",
           [15] = "femton",
           [16] = "sexton",
           [17] = "sjutton",
           [18] = "arton",
           [19] = "nitton",
           [20] = "tjugo",
           [30] = "trettio",
           [40] = "fyrtio",
           [50] = "femtio",
           [60] = "sextio",
           [70] = "sjuttio",
           [80] = "åttio",
           [90] = "nittio",
          [100] = "hundra",
         [10^3] = "tusen",
         [10^6] = "miljon",
         [10^9] = "miljard",
        [10^12] = "biljon",
        [10^15] = "biljard",
    }

    local function translate(n,connector)
        local w = words[n]
        if w then
            return w
        else
            local t = { }
            local l = 0
            -- group of three digits to words, e.g. 123 -> etthundratjugotre
            local function triplets(n)
                if floor(n/100) > 0 then
                    l = l + 1 ; t[l] = words[floor(n/100)]
                    l = l + 1 ; t[l] = words[100]
                end
                if n%100 > 20 then
                    l = l + 1 ; t[l] = words[n%100-n%10]
                    if n%10 > 0 then
                        l = l + 1 ; t[l] = words[n%10]
                    end
                elseif n%100 > 0 then
                    l = l + 1 ; t[l] = words[n%100]
                end
            end
            -- loops through 10^15,10^12,...10^3, extracting groups of three digits
            -- to make words from, then adding names for order of magnitude
            for i=15,3,-3 do
                local triplet = floor(n/10^i)%10^3
                if triplet > 0 then
                    -- grammar: "en" instead of "ett"
                    if i > 3 and triplet == 1 then
                        l = l + 1 ; t[l] = "en"
                    else
                        triplets(triplet)
                    end
                    -- grammar: plural form of "millions" etc
                    l = l + 1 ; t[l] = words[10^i]
                    if i > 3 and triplet > 1 then
                        l = l + 1 ; t[l] = "er"
                    end
                end
            end
            -- add last group of three numbers (no word for magnitude)
            n = n%1000
            if n > 0 then
                triplets(n)
            end
            t = concat(t," ")
            -- grammar: spacing for numbers < 10^6 and repeated letters
            if n < 10^6 then
                t = gsub(t,"%stusen%s","tusen")
                t = gsub(t,"etttusen","ettusen")
            end
            return t
        end
    end

    data.swedish = {
        words     = words,
        translate = translate,
    }

    data.sv = data.swedish

end


-- verbose finnish

do

    local words = {
            [0] = "nolla",
            [1] = "yksi",
            [2] = "kaksi",
            [3] = "kolme",
            [4] = "nejlä",
            [5] = "viisi",
            [6] = "kuusi",
            [7] = "seitsemän",
            [8] = "kahdeksan",
            [9] = "yhdeksän",
           [10] = "kymmenen",
           [11] = "yksitoista",
           [12] = "kaksitoista",
           [13] = "kolmetoista",
           [14] = "neljätoista",
           [15] = "viisitoista",
           [16] = "kuusitoista",
           [17] = "seitsemäntoista",
           [18] = "kahdeksantoista",
           [19] = "yhdeksäntoista",
           [20] = "kaksikymmentä",
           [30] = "kolmekymmentä",
           [40] = "neljäkymmentä",
           [50] = "viisikymmentä",
           [60] = "kuusikymmentä",
           [70] = "seitsemänkymmentä",
           [80] = "kahdeksankymmentä",
           [90] = "yhdeksänkymmentä",
          [100] = "sata", --plural "sataa"
         [10^3] = "tuhat", --plural "tuhatta"
         [10^6] = "miljoona",
         [10^9] = "miljardi",
        [10^12] = "biljoona",
        [10^15] = "biljardi",
    }

    local function translate(n,connector)
        local w = words[n]
        if w then
            return w
        else
            local t = { }
            local l = 0
            -- group of three digits to words, e.g. 123 -> etthundratjugotre
            local function triplets(n)
                if floor(n/100) > 0 then
                    l = l + 1 ; t[l] = words[floor(n/100)]
                    l = l + 1 ; t[l] = words[100]
                    if floor(n/100) > 1 then
                        l = l + 1 ; t[l] = "a"
                    end
                end
                if n%100 > 20 then
                    l = l + 1 ; t[l] = words[n%100-n%10]
                    if n%10 > 0 then
                        l = l + 1 ; t[l] = words[n%10]
                    end
                elseif n%100 > 0 then
                    l = l + 1 ; t[l] = words[n%100]
                end
            end
            -- loops through 10^15,10^12,...10^3, extracting groups of three digits
            -- to make words from, then adding names for order of magnitude
            for i=15,3,-3 do
                local triplet = floor(n/10^i)%10^3
                if triplet > 0 then
                    -- grammar: "en" instead of "ett"
                    if i > 3 and triplet == 1 then
                        l = l + 1 ; t[l] = "en"
                    else
                        triplets(triplet)
                    end
                    -- grammar: plural form of "millions" etc
                    l = l + 1 ; t[l] = words[10^i]
                    if i > 3 and triplet > 1 then
                        l = l + 1 ; t[l] = "er"
                    end
                end
            end
            -- add last group of three numbers (no word for magnitude)
            n = n%1000
            if n > 0 then
                triplets(n)
            end
            return concat(t,"")
        end
    end

    data.finnish = {
        words     = words,
        translate = translate,
    }

    data.fi = data.finnish

end
