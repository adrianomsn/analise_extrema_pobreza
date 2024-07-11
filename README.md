# Análise das perspectivas da extrema pobreza no Ceará
# INTRODUÇÃO

Na economia o tema pobreza é discutido incansavelmente, dada sua importância e relevânte influência no bem-estar social de uma população. Nos cenários onde os pesquisadores buscam entender o fenômeno da pobreza e como ocorre em uma determinada região, é necesssário abarcar indicadores que simulem a realidade do contexto inserido desses povos. Tendo em vista isso essa análise faz uso dos dados referentes a população de 184 municípios do estado do Ceará. A análise busca entender as condições da pobreza espacial da região. A análise consistiu no uso de inferência econométrica com modelo de regressão linear multipla, além de testes análisando a violação de premissas do modelo, com testes de multicolinearidade, heterocedasticidade, normalidade de resíduos e autocorrelação entre as variáveis. Da experiência internacional é consenso a realidade da pobreza no Brasil, tendo vista o grau de desenvolvimento emergente do país (IPECE, 2010). Para estabelecer o conceito de pobreza, Sen (1976) observou que a sua construção requer a solução de dois problemas: i) Identificar o conjunto da população de pessoas em estado de pobreza; e ii) Agregar características dessa população em um indicador (ou índice) de pobreza. Existem diversos estudos acerca da caracterização multifacetada da pobreza, evidenciando que ela não se resume a apenas pela má distribuição de renda. Essa análise busca por meio dessas ideias  analisar se caracteristicas como a taxa de analfabetismo, renda per capita, a população rural e a taxa de dependência tem imapcto significativo no grau de extrema pobreza no Ceará para o ano de 2010.

# OBJETIVOS

Entender se há e como ocorre o fenômeno da extrema pobreza no nordeste brasileiro. Quais aspectos socioeconômicos determinam o estado de extrema pobreza de uma população e onde é possível dar visibilidade para fomentar a ação de políticas públicas de qualidade visando sanar essa problemática.


# METODOLOGIA

Os dados oriundos do Censo de 2010 obtidos através do Atlas do Desenvolvimento Humano no Brasil e as observações consistem todos os municípios do estado do Ceará que contém população rural. O modelo utilizado foi uma regressão linear multiplica (log-log), além da análise descritiva dos dados, análise de premissa e dos resultados da regressão..


## Resumo das variáveis:
- PER_EXTPOBRE_2010 = porcentagem de pessoas em extrema pobreza; 
- POP_R2010 = população rural; 
- RDEP_2010 = razão de dependência; 
- TX_ANALF2010 = taxa de analfabetismo para indivíduos com 18 anos ou mais de idade; 
- RPC_2010 = renda per capita; 
- O subscrito i indica os 184 municípios cearenses;
- Ano referente as observações, onde t = 2010.
	

## Hipóteses levantadas
É esperado relação positiva entre a % de pessoas extremamente pobres, taxa de analfabetismo e população rural. Dessa forma, com incrementos na taxa de analfabetismo e população rural, tenha-se um aumento na % de pessoas extremamente pobres. O sinal esperado para a relação renda per capita, razão de dependência e a % de extremamente pobres é negativa. Ou seja, espera-se que com um aumento na renda per capita e razão de dependência haja redução na porcentagem de pessoas extremamente pobres.

# RESULTADOS

Os resultados foram divididos em duas subdivisões, sendo elas: Estatística descritiva e interpretação do modelo econométrico.

Tabela 1 – Estatística descritiva das variáveis utilizadas na regressão.

![image](https://github.com/adrianomsn/analise_extrema_pobreza/assets/170030446/7b2d2b3b-6938-46fe-9da5-351b333d6813)

Tabela 2 – Resultados do modelo econométrico.

![image](https://github.com/adrianomsn/analise_extrema_pobreza/assets/170030446/e9f81c09-4487-4bc6-bf6c-547cb76b5b9c)


As variáveis analisadas em sua maioria se comportam como esperado, exceto pela razão de dependência, na qual esperava-se uma relação inversa entre esta e a % de extremamente pobres. Contudo, o modelo demonstrou relação direta entre as variáveis.
## Taxa de analfabetismo
A taxa de analfabetismo, afeta de forma positiva a variável dependente. O aumento de 1% na taxa de analfabetismo aumenta em 0,834% a variável dependente.
## População rural
A população rural afeta de forma positiva a variável dependente. O aumento de 1% na população rural aumenta em 0,078% o percentual de extremamente pobres. Evidenciando o já afirmado por Albuquerque e Cunha (2012) de que a pobreza extrema é mais presente no ambiente rural do Brasil.
## Razão de dependência
Existe relação positiva entre a razão de dependência e a variável dependente, onde vemos que, um aumento de 1% na taxa de dependência aumenta em 0,818% o percentual de pessoas em extrema pobreza. Correlação esta que também foi noticiada por Zaranza, ao observar que pessoas mais pobres tendem a ter prole mais numerosa, o que resulta no aumento da razão de dependência. 
## Renda per capita
Existe relação negativa entre extrema pobreza e a renda per capita. Ou seja, temos que com o aumento de 1% na renda per capita acaba por reduzir a extrema pobreza em 0,9%. Considerando o aumento da renda como crescimento econômico, o resultado encontrado por Barros e Mendonça (1997), de que qualquer crescimento econômico pode de alguma forma favorecer os pobres.
## Intercepto
Sobre o intercepto da regressão, nada podemos afirmar dado que o seu resultado se mostrou insignificante estatisticamente para ∝ = 1%, 5% e 10%. O modelo apresenta  significância global (p-valor<0,05 segundo o teste F) além do elevado grau de ajuste com cerca de 84,8% das seu repressores explicando as variações na porcentagem de pessoas em extrema pobreza para os municípios do Ceará no ano de 2010.


# CONCLUSÃO
De acordo com as informações obtidas, as variáveis explicativas utilizadas demonstraram um efeito sobre a população em extrema pobreza no estado do Ceará. Variáveis essas em sua maioria de caráter demográfico e socioeconômico, o que poderá servir de insumo para guiar políticas públicas focalizadas para intervir em aspectos dos municípios cearenses guiados por esta análise. E dessa forma, podendo promover mudançar e políticas mais impactantes visando o aumento do desenvolvimento socioeconômico e do bem-estar geral.








