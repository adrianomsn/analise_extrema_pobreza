# ANÁLISE DOS DETERMINANTES DA EXTREMA POBREZA NO CEARÁ

# INTRODUÇÃO

Na economia o tema pobreza é discutido incansavelmente, dada sua importância e relevânte influência no bem-estar social de uma população. Nos cenários onde os pesquisadores buscam entender o fenômeno da pobreza e como ocorre em uma determinada região, é necesssário abarcar indicadores que simulem a realidade do contexto inserido desses povos. Tendo em vista isso essa análise faz uso dos dados referentes a população de 184 municípios do estado do Ceará. A análise busca entender as condições da pobreza espacial da região. A análise consistiu no uso de inferência econométrica com modelo de regressão linear multipla, além de testes análisando a violação de premissas do modelo, com testes de multicolinearidade, heterocedasticidade, normalidade de resíduos e autocorrelação entre as variáveis. Da experiência internacional é consenso a realidade da pobreza no Brasil, tendo vista o grau de desenvolvimento emergente do país (IPECE, 2010).
Para estabelecer o conceito de pobreza, Sen (1976) observou que a sua construção requer a solução de dois problemas:
 
 i) Identificar o conjunto da população de pessoas em estado de pobreza;
 
 ii) Agregar características dessa população em um indicador (ou índice) de pobreza.

Existem diversos estudos acerca da caracterização multifacetada da pobreza, evidenciando que ela não se resume a apenas pela má distribuição de renda. Essa análise busca por meio dessas ideias  analisar se caracteristicas como a taxa de analfabetismo, renda per capita, a população rural e a taxa de dependência tem imapcto significativo no grau de extrema pobreza no Ceará para o ano de 2010.

# OBJETIVOS

Entender se há e como ocorre o fenômeno da extrema pobreza no nordeste brasileiro. Quais aspectos socioeconômicos determinam o estado de extrema pobreza de uma população e onde é possível dar visibilidade para fomentar a ação de políticas públicas de qualidade visando sanar essa problemática.


# METODOLOGIA

Os dados oriundos do Censo de 2010 obtidos através do Atlas do Desenvolvimento Humano no Brasil e as observações consistem todos os municípios do estado do Ceará que contém população rural. O modelo utilizado foi uma regressão linear multiplica (log-log), além da análise descritiva dos dados, análise de premissa e dos resultados da regressão..


## Resumo das variáveis:

- PERC_EXT_POB = porcentagem de pessoas em extrema pobreza.
- PERC_OC_AGRO = porcentagem de ocupação no setor agropecuário;
- PERC_OC_COMERC = porcentagem de ocupação no setor comercial;
- PERC_OC_SERV = porcentagem de ocupação no setor de serviços;
- ESP_VIDA_NSC = esperança de vida ao nascer;
- POP_RURAL = população rural;
- RAZ_DEP = razão de dependência;
- TX_ANAF = taxa de analfabetismo;
- FREQ_PRE_ESC = frequência escolar na educação pré-escolar;
- FREQ_FUND = frequência escolar no ensino fundamental;
- FREQ_MED = frequência escolar no ensino médio;
- PIB_PC = PIB per capita;

  
- O subscrito i indica os 184 municípios cearenses.
- Ano referente às observações, onde t = 2010.

# Análise Exploratória

## Medidas de Tendência Central

### - Média por variáveis:
```
- perc_oc_agro:    38.18
- perc_oc_comerc:  11.43
- perc_oc_serv:    31.62
- esp_vida_nsc:    70.67
- pop_rural:       11570.44
- raz_dep:         56.61
- tx_anaf:         27.28
- freq_pre_esc:    71.93
- freq_fund:       112.89
- freq_med:        65.44
- pib_pc:          267.63
- perc_ext_pob:    23.47
```

### - Desvio Padrão:
```
Variáveis com alto desvio padrão:

pop_rural (8.026) e pib_pc (62.80) têm desvios padrão elevados,
indicando alta variabilidade nos valores dessas variáveis.

Variáveis com desvio padrão moderado:

perc_oc_agro (12.65), freq_pre_esc (16.78), e freq_med (10.67)
apresentam desvios padrão moderados, sugerindo variação considerável, mas não extrema.

Variáveis com baixo desvio padrão:

perc_oc_comerc (3.37, perc_oc_serv (5.5), esp_vida_nsc (1.28),
raz_dep (5.3), tx_anaf (5.3), freq_fund (4.8), e perc_ext_pob (8.69) têm desvios padrão menores,
indicando menor variação nos valores dessas variáveis.

```
### Quartis:
```
1º e 3º Quartil:

- pop_rural:       11570.44
 Q1 = 5948, temos 25% dos municípios com população rural abaixo desse valor;
 Q3 = 14556, temos 25% dos municípios com população rural acima desse valor.
 ou seja, metade dos municípios cearenses em 2010 tinha população rural entre 5948 a 14556 pessoas.

- raz_dep:
 Q1 = 52.9, temos 25% dos municípios com razão de dependência abaixo desse valor;
 Q3 = 60.3, temos 25% dos municípios com razão de dependência acima desse valor.
 ou seja, metade dos municípios cearenses em 2010 tinha razão de dependência entre 52% a 60%. Questão essa que pode influênciar diretamente a extrema pobreza, vale notar que seria basicamente para cada 100 trabalhadores ativos
 haveria pelo menos 50 a 60 pessoas dependentes.

- tx_anaf:
 Q1 = 24.2, temos 25% dos municípios com taxa de analfabetismo abaixo desse valor;
 Q3 = 30.5, temos 25% dos municípios com taxa de analfabetismo acima desse valor.
 ou seja, metade dos municípios cearenses em 2010 tinha taxas de analfabetismo entre 24 a 30%.

- pib_pc:          267.63
 Q1 = R$ 221, temos 25% dos municípios com PIB per capita abaixo desse valor;
 Q3 = R$ 287, temos 25% dos municípios com PIB per capita acima desse valor.
 ou seja, metade dos municípios cearenses em 2010 tinha PIB per capita entre 221 a 287 reais. Recobrando dados de salário em 2010, esse valor equivale a metade de um salário mínimo naquele ano.

- perc_ext_pob:    23.47
 Q1 = 17.6, temos 25% dos municpios com percentual de pessoas em extrema pobreza abaixo desse valor;
 Q3 = 30.1, temos 25% dos municpios com percentual de pessoas em extrema pobreza acima desse valor.
 ou seja, metade dos municípios cearenses em 2010 tinha um percentual de pessoas em extrema pobreza de 17,6% a 30.1%.

- exp_vida_nsc:    23.47
 Q1 = 69.8, temos 25% dos municpios com expectiva de vida ao nascer abaixo desse valor;
 Q3 = 71.5, temos 25% dos municpios com expectiva de vida ao nascer acima desse valor.
 ou seja, pelo menos 75% dos municípios cearenses em 2010 tinham expectativa de vida ao nascer superior a 69.8 anos.

### Resumo geral:
Em outras palavras 75% dos municípios cearenses em 2010 sobreviviam com cerca de metade de um salário mínimo ou menos, com altissíma razão de dependência, taxa de analfabetismo pelo menos 2 vezes maior que a média brasileira para a época, 
alto percentual de pessoas em extrema pobreza e expectativa de vida superior a 69.8 anos.

```
## Outliers

### Resumo dos resultados:

Com p-valor menor que 0,05, rejeita-se a hipótese nula. Portanto, são de fato outliers:
```
- perc_oc_comerc: 27.38
Valor este referente ao município de Juazeiro do Norte com alto percentual de ocupação no setor de comércio.

- perc_oc_serv: 51.55
Valor este referente ao município de Fortaleza (Capital) com alto percentual de ocupação no setor de comércio.

- pop_rural: 49156
Valor este referente ao município de Itapipoca com alta quantidade da população em zona rural.

- tx_anaf: 6.94
Valor este referente ao município de Fortaleza (Capital) com baixissíma taxa de analfabetismo.

- freq_fund: 136.07
Valor este referente ao município de Tabuleiro do Norte com altissímop valor de frequência escolar no fundamental.

- pib_pc: 846.36
Valor este referente ao município de Fortaleza (Capital) com alto valor do PIB per capita.
_obs: Fortaleza foi considerado outlier impactante e portanto removido da amostra_

```

## Distribuição das variáveis
![image](https://github.com/user-attachments/assets/d24ad2e3-3faa-48d4-a72a-b95188a9348a)

### - Expectativa de Vida ao Nascer:  
```
A distribuição é aproximadamente normal com um pico em torno de 71 anos.
A densidade diminui dos dois lados do pico, indicando menos variabilidade em valores extremos.
```
### - Frequência no Ensino Fundamental: 
```
A distribuição é levemente assimétrica para a direita, com um pico em torno de 112.
Há uma menor frequência de valores muito baixos ou muito altos.
```
### - Frequência no Ensino Médio:
```
A distribuição é aproximadamente normal, centrada em torno de 63.
A densidade é bem distribuída com um leve aumento na cauda direita.
```
### - Frequência na Pré-Escola:
```
A distribuição é bimodal, com picos em torno de 65 e 85.
Há uma menor frequência de valores extremos.
```
### - Percentual de Extrema Pobreza:
```
A distribuição é aproximadamente normal com um pico em torno de 25.
A densidade é distribuída simetricamente ao redor do pico.
```
### - Percentual de Ocupação na Agricultura:
```
A distribuição é levemente assimétrica para a direita, com um pico em torno de 20.
Há uma menor frequência de valores muito altos.
```
### - Percentual de Ocupação no Comércio:
```
A distribuição é aproximadamente normal com um pico em torno de 10.
A densidade diminui dos dois lados do pico.
```
### - Percentual de Ocupação nos Serviços:
```
A distribuição é aproximadamente normal com um pico em torno de 30.
A densidade é bem distribuída com menos valores extremos.
```
### - PIB per capita:
```
A distribuição é assimétrica para a direita, com a maioria dos valores concentrados abaixo de 1000.
Há alguns valores extremos muito altos, indicando desigualdade.
```
### - População Rural:
```
A distribuição é extremamente assimétrica para a direita.
A maioria dos valores está concentrada abaixo de 50.000, mas há valores extremos muito altos.
```
### - Razão de Dependência:
```
A distribuição é aproximadamente normal com um pico em torno de 55.
A densidade diminui dos dois lados do pico, indicando variabilidade em valores extremos.
```
### - Taxa de Analfabetismo:
```
A distribuição é aproximadamente normal com um pico em torno de 25.
A densidade diminui dos dois lados do pico.
```
## Matrizes de correlação

![image](https://github.com/user-attachments/assets/453e7925-c5c8-403f-b3b6-8506360572c4)

## 1 - Correlações positivas:

## tx_anaf e raz_dep
Correlação entre as duas variáveis no patamar de 0.74, indicando assim uma forte correlacao.
Em outras palavras, a medida que a taxa de analfabetismo aumenta, a razao de dependência
tambem tende a aumentar. então municipios e regioes com maiores taxas de analfabetismo tbm tem maior razao
de dependencia

## perc_oc_agro e tx_anaf
Correlação entre essas variáveis foi no patamar de 0.74 tambem, indicando uma forte correlacao.
Em outras palavras, o percentual de ocupados no setor agropecuario  demonstra grande influência
em uma maior taxa de analfabetismo. Creio que isso tenha a ver com o fato do trabalho rural haver
maior concentracao de mao de obra menos especializada.

## perc_ext_pob e tx_anaf
Correlação entre essas variáveis demonstrou um valor de 0.79, ou seja, a taxa de analfabetismo tende
a aumentar quando o percentual de pessoas em extrema pobreza aumenta.

## perc_ext_pob e raz_dep
Outro par de variáveis que demonstrou altissima Correlação que um maior percentual de pessoas em extrema pobreza
está associada a uma maior razão de dependencia.

## 2 - Correlações negativas:

## perc_ext_pob e pib_pc
Correlação de -0.8 demonstrando forte relacao, indicando que a medida que o pib per capita aumenta o percentual de pessoas em extrema
pobreza tende a diminuir consideravelmente.

## perc_oc_comerc e perc_oc_agro
Correlação negativamente moderada com -0.59, sao duas variáveis em sentidos opostos então ísso indica tbm na correlacao que percentual de ocupacao
no setor agropecuario tende a diminuir a medida que o percentual de ocupacao do setor comercial aumenta.

## esp_vida_nsc e perc_oc_agro
Correlação negativa moderada de -0.44, indicando que ha uma relacao inversa, ou seja, a esperanca de vida ao nascer tende a aumentar com
um menor percentual de ocupacao no setor agropecuario. Ou seja, pode denotar que regioes mais dependende do setor agropecuario tendem a ter
menos esperanca de vida ao nascer nos municipios cearenses.

## pib_pc e raz_dep
Correlação negativa moderadamente forte de -0.65, indicando que a razao de dependência diminui a medida que o pib per capita aumenta.

## pib_pc e tx_anaf
Correlação negativa moderadamente forte de -0.73, indicativo que a medida que pib per capita aumenta a taxa de analfabetismo diminui.

# tx_anaf e esp_vida_nsc
Correlação negativa relativamente forte de -0.47, denotando uma possivel relacao. Onde, municipios com maiores taxas de analfabetismo
tendem a ter menor esperanca de vida ao nascer.

# Testes Estatísticos de Diagnóstico

## Teste de Confirmação de outliers
```
outlierTest(model_ext)
```
Esse teste confirma a observacao 59 (Fortaleza - Capital) como outlier significativo, portanto a observação foi removida da base
de dados. Remoção essa que melhorou a acurária do modelo levemente. 

## Teste de Normalidade da Distribuição
```
shapiro.test(residuals(model_ext))
```
p-valor > 0.05 portanto nao rejeitamos a hipotese nula de normalidade da distruicao

## Teste de Heterocedasticidade
```
bptest(model_ext)
```
p-valor > 0.05 portanto nao reijeitamos a hipotese nula de homocedasticidade ( variancia constante )

## Teste de Autocorrelação
```
dwtest(model_ext)
```
p-valor > 0.05 portanto nao rejeitamos a hipotese nula de que nao ha autocorrelacao.

## Teste de multicolinearidade
```
vid_lm <- vif(model_ext)
print(vid_lm)
```
Analisando os resultados do VIF podemos notar que todos os resultados sao abaixos de 5, ou seja,
muito inferiores a 10. Portanto, nao temos problema com multicolinearidade no modelo.

# RESULTADOS

Os resultados foram divididos em duas subdivisões, sendo elas: Estatística descritiva e interpretação do modelo econométrico.

Tabela 1 – Estatística descritiva das variáveis utilizadas na regressão.

```
perc_oc_agro   perc_oc_comerc   perc_oc_serv    esp_vida_nsc     pop_rural        raz_dep         tx_anaf       freq_pre_esc      freq_fund        freq_med    
 Min.   : 0.80   Min.   : 4.09   Min.   :17.37   Min.   :67.56   Min.   :  252   Min.   :41.16   Min.   : 6.94   Min.   : 31.79   Min.   :100.8   Min.   :36.48  
 1st Qu.:30.90   1st Qu.: 9.23   1st Qu.:27.34   1st Qu.:69.89   1st Qu.: 5948   1st Qu.:52.99   1st Qu.:24.26   1st Qu.: 60.32   1st Qu.:110.0   1st Qu.:58.38  
 Median :40.27   Median :10.82   Median :31.50   Median :70.63   Median : 9372   Median :56.69   Median :28.05   Median : 72.51   Median :112.6   Median :65.45  
 Mean   :38.19   Mean   :11.44   Mean   :31.63   Mean   :70.67   Mean   :11570   Mean   :56.61   Mean   :27.28   Mean   : 71.93   Mean   :112.9   Mean   :65.45  
 3rd Qu.:47.77   3rd Qu.:13.36   3rd Qu.:34.66   3rd Qu.:71.50   3rd Qu.:14556   3rd Qu.:60.39   3rd Qu.:30.55   3rd Qu.: 84.64   3rd Qu.:115.5   3rd Qu.:72.42  
 Max.   :62.65   Max.   :27.38   Max.   :51.55   Max.   :74.93   Max.   :49156   Max.   :68.10   Max.   :39.98   Max.   :119.33   Max.   :136.1   Max.   :94.94  
     pib_pc       perc_ext_pob  
 Min.   :171.6   Min.   : 3.36  
 1st Qu.:221.1   1st Qu.:17.64  
 Median :258.6   Median :23.51  
 Mean   :267.6   Mean   :23.48  
 3rd Qu.:287.8   3rd Qu.:30.12  
 Max.   :846.4   Max.   :43.63  
 ``` 
Tabela 2 – Resultados do modelo econométrico.
```
Resultados da Regressão
===============================================
                        Dependent variable:    
                    ---------------------------
                         log(perc_ext_pob)     
                               model           
-----------------------------------------------
log(pop_rural)                0.072***          
                              (0.019)                                                         
log(raz_dep)                  0.823***          
                              (0.176)                                                      
log(tx_anaf)                  0.515***          
                              (0.108)                                                        
log(pib_pc)                   -0.987***         
                              (0.103)                                                        
log(esp_vida_nsc)             -0.141           
                              (0.748)                                                       
log(perc_oc_agro)             0.194***          
                              (0.045)                                                       
log(perc_oc_comerc)           0.108*           
                              (0.056)                                                        
log(perc_oc_serv)             0.239***          
                              (0.083)                                                        
log(freq_pre_esc)             -0.034           
                              (0.051)                                                        
log(freq_fund)                -0.130           
                              (0.293)                                                        
log(freq_med)                 -0.016           
                              (0.077)                                                        
Constant                       2.546           
                              (3.544)                                                        
-----------------------------------------------
Observations                    186            
R2                             0.878           
Adjusted R2                    0.870           
Residual Std. Error      0.161 (df = 174)      
F Statistic          113.979*** (df = 11; 174) 
===============================================
Note:               *p<0.1; **p<0.05; ***p<0.01
```

#   Interpretação dos resultados do modelo 

## Resultado das variáveis explicativas individualmente em relacao a variavel dependente

# Variveis significativas:

### 1 - População rural: 0.072, p < 0.01
Um aumento de 1% na população rural está associado a um aumento de 0.072% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

### 2 - Razão de dependência: 0.823, p < 0.01
Um aumento de 1% na razão de dependência está associado a um aumento de 0.823% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

### 3 - Taxa de Analfabetismo: 0.515, p < 0.01
Um aumento de 1% na taxa de analfabetismo está associado a um aumento de 0.515% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

### 4 - PIB per capita: -0.987, p < 0.01
Um aumento de 1% no PIB per capita está associado a uma diminuição de 0.987% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

### 5 - Percentual de ocupaçao no setor agropecuário: 0.194, p < 0.01
Um aumento de 1% na percentual de ocupação no setor agropecuário está associado a um aumento de 0.194% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

### 6 - Percentual de ocupação no setor de serviços: 0.239, p < 0.01
um aumento de 1% na percentual de ocupação no setor de serviços está associado a um aumento de 0.239% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

 
# variáveis nao significativas:

- esp_vida_nsc: -0.141, p > 0.1
- perc_oc_comerc: 0.064, p > 0.1
- freq_pre_esc: -0.051, p > 0.1
- freq_fund:-0.011, p > 0.1
- freq_med: -0.011, p > 0.1
- intercepto: 2.388, p > 0.1

Todas as variáveis acima nao tiveram efeito significativo no percentual de pessoas em extrema pobreza.


## Interpretação geral:

- O modelo de regressão log-log apresentou um ajuste muito bom aos dados, com um R² ajustado de 0.869,
indicando que aproximadamente 87,88% da variação em log(perc_ext_pob) é explicada pelas variáveis independentes do modelo.

- As variáveis mais significativas (p < 0.01) que afetam a percentagem de extrema pobreza são log(pop_rural), log(raz_dep),
log(tx_anaf), log(pib_pc), log(perc_oc_agro) e log(perc_oc_serv). Isso sugere que a população rural, a razão de dependência,
a taxa de analfabetismo, o PIB per capita, a ocupação no setor agropecuário e a ocupação no setor de serviços são fatores
cruciais para a determinação da extrema pobreza.

- Algumas variáveis, como a esperança de vida ao nascer, a percentagem de ocupação no comércio, a frequência pré-escolar,
a frequência no ensino fundamental e a frequência no ensino médio, não mostraram significância estatística, indicando que,
dentro deste modelo, esses fatores não têm um impacto significativo na percentagem de extrema pobreza.

# Conclusão

## Insights e implicações em políticas públicas

Alguns direcionamentos que podemos inferir é a necessidade de politicas rurais de desenvolvimento, dado a relaçao encontrada
entre populaçao rural e o percentual de pessoas em extrema pobreza, políticas focadas nesse grupo podem trazer melhorias de bem estar
no campo, tendo em vista a diminuicao da extrema pobreza nos municipios do estado do ceará. No entanto, quando falamos sobre educação
foi possivel notar a extrema necessidade da boas taxas de alfabetizacao podendo ter efeitos muito positivos sobre o percentual de pessoas
em extrema pobreza, mas é interessante ressaltar que apenas a presença alta em todas as etapas estudantis nao demonstraram ter nenhuma
efeito significativo na redução da extrema pobreza, o que pode indicar por um lado onde a qualidade da educação ofertada e a  oferta de oportunidade
de educação  e manuntencao de boas taxas alfabetizacao possam surtir efeitos positivos na redução da extrema pobreza. Em relacao ao desenvolvimento
econômico podemos evidenciar o forte impacto do crescimento econômico e aumento do pib per capita na redução da extrema pobreza, mas claro tambem
dando mesma importancia na distribuicao mais equitaria dos recursos gerados em excedente. Acerca dos setores de emprego analisados demonstrou uma necessidade
da geracao de empregos de qualidade e foco em empregabilidade formal, dado que possa ocorrer o contrario no campo e regioes mais ruralizadas e menos populosas,
então o desenvolvimento desses setores possam gerar mais empregos, mas tambem reduzir a extrema pobreza.









