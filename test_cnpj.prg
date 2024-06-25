/* 
MIT License

Copyright (c) 2024 eduardomotta-emottasistemas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

Function test_cnpj()

// TESTES CNPJ COM DIGITOS CORRETOS
    ? "cnpj correto com mascara e sem letras"
    cCnpj := "03.170.763/0001-79"
    cCnpj_with_picture := ""
    ? ValToPrg({cCnpj, Validate_Cnpj(@cCnpj, @cCnpj_with_picture), cCnpj, cCnpj_with_picture})
    ? Replicate("*", 40)

    ?
    ? "cnpj correto sem mascara e sem letras"
    cCnpj := "03170763000179"
    cCnpj_with_picture := ""
    ? ValToPrg({cCnpj, Validate_Cnpj(@cCnpj, @cCnpj_with_picture), cCnpj, cCnpj_with_picture})
    ? Replicate("*", 40)

    ?
    ? "cnpj correto com mascara e com letras"
    cCnpj := "A3.170.7X3/0001-36"
    cCnpj_with_picture := ""
    ? ValToPrg({cCnpj, Validate_Cnpj(@cCnpj, @cCnpj_with_picture), cCnpj, cCnpj_with_picture})
    ? Replicate("*", 40)

    ?
    ? "cnpj correto sem mascara e com letras"
    cCnpj := "A31707X3000136"
    cCnpj_with_picture := ""
    ? ValToPrg({cCnpj, Validate_Cnpj(@cCnpj, @cCnpj_with_picture), cCnpj, cCnpj_with_picture})
    ? Replicate("*", 40)

// TESTES CNPJ COM DIGITOS ERRADOS
    ?
    ? "cnpj errado com mascara e sem letras"
    cCnpj := "03.170.763/0001-12"
    cCnpj_with_picture := ""
    ? ValToPrg({cCnpj, Validate_Cnpj(@cCnpj, @cCnpj_with_picture), cCnpj, cCnpj_with_picture})
    ? Replicate("*", 40)

    ?
    ? "cnpj errado sem mascara e sem letras"
    cCnpj := "03170763000112"
    cCnpj_with_picture := ""
    ? ValToPrg({cCnpj, Validate_Cnpj(@cCnpj, @cCnpj_with_picture), cCnpj, cCnpj_with_picture})
    ? Replicate("*", 40)

    ?
    ? "cnpj errado com mascara e com letras"
    cCnpj := "A3.170.7X3/0001-20"
    cCnpj_with_picture := ""
    ? ValToPrg({cCnpj, Validate_Cnpj(@cCnpj, @cCnpj_with_picture), cCnpj, cCnpj_with_picture})
    ? Replicate("*", 40)

    ?
    ? "cnpj errado sem mascara e com letras"
    cCnpj := "A31707X3000120"
    cCnpj_with_picture := ""
    ? ValToPrg({cCnpj, Validate_Cnpj(@cCnpj, @cCnpj_with_picture), cCnpj, cCnpj_with_picture})
    ? Replicate("*", 40)

Return

/*
passar cCnpj é obrigatório mas por referencia é opcional
passar cCnpj_with_picture é opcional mas se passado deve ser sempre por referencia
*/
Function Validate_Cnpj(cCnpj, cCnpj_with_picture)
Local digitWeights := {6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2}
Local clearedCNPJ
Local formattedCNPJ := cCnpj
Local n := 0
Local i
Local digit_13 := ""
Local digit_14 := ""
Local ASC_CODE_BASE := 48

clearedCNPJ := StrTran(cCnpj, ".", "")
clearedCNPJ := StrTran(clearedCNPJ, "/", "")
clearedCNPJ := StrTran(clearedCNPJ, "-", "")

formattedCNPJ := PadR(clearedCNPJ, 12)

If Len(formattedCNPJ) # 12
    return .f.
EndIf

For i := 2 to 13
    n += ((Asc(formattedCNPJ[i - 1]) - ASC_CODE_BASE) * digitWeights[i])
Next
digit_13 := Str(if(Mod(n, 11) < 2, 0, 11 - Mod(n, 11)), 1)
formattedCNPJ += digit_13
n = 0;

For i := 1 to 13
    n += ((Asc(formattedCNPJ[i]) - ASC_CODE_BASE) * digitWeights[i])
Next
digit_14 := Str(if(Mod(n, 11) < 2, 0, 11 - Mod(n, 11)), 1)
formattedCNPJ += digit_14 

cCnpj_with_picture := Transform(formattedCNPJ, "@R XX.XXX.XXX/9999-99")

if ! formattedCNPJ == clearedCNPJ
    cCnpj := formattedCNPJ
    return .f.
endif

return .t.
