local floor = math.floor
local concat = table.concat

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
         [10^6] = "miljoona", --plural "miljoonaa"
         [10^9] = "miljardi", --plural "miljardit"
        [10^12] = "biljoona", --plural "biljoonaa"
        [10^15] = "biljardi", --plural "biljardit"
    }

    local function translate(n,connector)
        local w = words[n]
        if w then
            return w
        else
            local t = { }
            local l = 0
            -- group of three digits to words
            local function triplets(n)
                if floor(n/100) > 0 then
                    l = l + 1 ; t[l] = words[floor(n/100)]
                    l = l + 1 ; t[l] = words[100]
                    --plural for 100
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
            -- loops through 10^15,10^12,...10^0, extracting groups of three digits
            -- to make words from, then adding names for order of magnitude
            for i=15,0,-3 do
                local triplet = floor(n/10^i)%10^3
                if triplet > 0 then
                    triplets(triplet)
                    if i > 0 then
                        l = l + 1 ; t[l] = words[10^i]
                        -- plural forms
                        if triplet > 1 then
                            if i == 15 or i == 9 then                    
                                l = l + 1 ; t[l] = "t"
                            end
                            if i == 12 or i == 6 then
                                l = l + 1 ; t[l] = "a"
                            end
                            if i == 3 and triplet > 1 then
                                l = l + 1 ; t[l] = "ta"
                            end
                        end
                    end
                end
            end
            -- no spaces in finnish numbers
            return concat(t,"")
        end
    end

--    data.finnish = {
--        words     = words,
--        translate = translate,
--    }

--    data.fi = data.finnish


print(translate(tonumber(arg[1]),""))
end


