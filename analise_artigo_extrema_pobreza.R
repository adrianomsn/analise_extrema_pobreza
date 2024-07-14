###-------------------- Determinantes da Extrema Pobreza -----------------------------
### Gera analise de regressao da extrema pobreza
### AUTOR: ADRIANO NETO

### OBJETIVO: 

# Limpa o ambiente
rm(list = ls())

# Carrega/instala os pacotes necessários
pacotes = c(
  "tidyverse", "readxl", "dplyr", "stringr", "xgboost",
  "wooldridge", "lmtest", "faraway", "stargazer", "randomForest",
  "ggplot2", "tseries", "car", "corrplot", "PerformanceAnalytics", 
  "caret", "rmarkdown", "glmnet", "neuralnet", "e1071", "gbm", "rpart",
  "httr", "jsonlite", "writexl", "GGally", "outliers"
)


# Instala pacotes que ainda não estão instalados
for (x in pacotes) {
  if (!x %in% installed.packages()) {
    install.packages(x, repos = "http://cran.us.r-project.org")
  }
}

# Carrega os pacotes
lapply(pacotes, require, character.only = TRUE)
rm(pacotes, x)

# ------------------- Importacao de dados ---------------------------------------


# Carrega a base de dados
# base_extpob <- read_excel("C:/Users/super/Downloads/dados_extpob.xlsx")
base_extpob <- read_excel("C:/Users/super/Downloads/dados.xlsx")

# Resumo da base de dados
summary(base_extpob)

# ------------------------ Tratamento dos dados -------------------------------
# remove a observacao do brasil (dimensao diferente, estamos trabalhando com municipios)
base_extpob <- base_extpob [-1,]

# Verifica a quantidade de dados ausentes
missing_data <- sapply(base_extpob, function(x) sum(is.na(x)))
print(missing_data)

# # Remover linhas com dados ausentes (pode-se considerar imputação de dados como alternativa)
# base_extpob <- na.omit(base_extpob)

# Gerando base alternativa para manipulacao
base_extpob_alt <- base_extpob

# Padroniza a variavel municipio (nome e dados)
base_extpob_alt <- base_extpob_alt %>% 
  mutate(Territorialidades = gsub(" \\(CE\\)", "", Territorialidades)) %>% 
  mutate((Territorialidades = gsub("ç", "c", Territorialidades))) %>% 
  mutate((Territorialidades = gsub("Ç", "C", Territorialidades))) %>% 
  rename(municipio = "Territorialidades") %>% 
  select(-`% de pobres 2010`)

# Padroniza todas as variaveis da base
base_extpob_alt <- base_extpob_alt %>% 
  rename(perc_oc_comerc = "% dos ocupados no setor comércio 2010",
         perc_oc_serv = "% dos ocupados no setor de serviços 2010",
         perc_oc_agro = "% dos ocupados no setor agropecuário 2010",
         esp_vida_nsc = "Esperança de vida ao nascer 2010" ,
         pop_rural = "População rural 2010",
         raz_dep = "Razão de dependência 2010",
         tx_anaf =  "Taxa de analfabetismo - 15 anos ou mais de idade 2010",
         freq_pre_esc = "Taxa de frequência bruta à pré-escola 2010",
         freq_fund = "Taxa de frequência bruta ao ensino fundamental 2010",
         freq_med = "Taxa de frequência bruta ao ensino médio 2010",
         pib_pc = "Renda per capita 2010",
         perc_ext_pob = "% de extremamente pobres 2010")

# Seleciona apenas variaveis numericas
numeric_cols <- sapply(base_extpob_alt, is.numeric)
base_extpob_numeric <- base_extpob_alt[, numeric_cols]

# Preenche os NA's com a média de cada variavel
for(i in seq_along(base_extpob_numeric)) {
  if (is.numeric(base_extpob_numeric[[i]])) {
    base_extpob_numeric[[i]][is.na(base_extpob_numeric[[i]])] <- mean(base_extpob_numeric[[i]], na.rm = TRUE)
  }
}

# Checa novamente numero de NA's
missing_data <- sapply(base_extpob_numeric, function(x) sum(is.na(x)))
print(missing_data)

# Cria um id para uniao das bases
base_extpob_alt <- base_extpob_alt %>% 
  mutate(id = row_number()) %>% 
  select(municipio, id)
base_extpob_numeric <- base_extpob_numeric %>% 
  mutate(id = row_number())

# Une as bases através do id
base_extpob_alt <- left_join(base_extpob_alt, base_extpob_numeric, by = "id")


# Remove o id apos uso das duas bases
base_extpob_alt <- base_extpob_alt %>% 
  select(-id)

base_extpob_numeric <- base_extpob_numeric %>% 
  select(-id)


# Função para remover acentos
remove_acentos <- function(texto) {
  iconv(texto, from = "UTF-8", to = "ASCII//TRANSLIT")
}

# Aplicando a função
base_extpob_alt <- base_extpob_alt %>%
  mutate(municipio = remove_acentos(municipio))

# Padroniza arredondamento 

# Arredonda percentuais para duas casas decimais
percent_cols <- c('perc_oc_agro', 'perc_oc_comerc', 'perc_oc_serv', 'perc_ext_pob')
base_extpob_numeric[percent_cols] <- lapply(base_extpob_numeric[percent_cols], function(x) round(x, 2))

# Arredonda valores absolutos para o número inteiro mais próximo
absolute_cols <- c('pop_rural')
base_extpob_numeric[absolute_cols] <- lapply(base_extpob_numeric[absolute_cols], function(x) round(x, 0))

# Arredonda índices para duas casas decimais
index_cols <- c('raz_dep', 'tx_anaf')
base_extpob_numeric[index_cols] <- lapply(base_extpob_numeric[index_cols], function(x) round(x, 2))

# Arredonda valores contínuos para duas casas decimais
continuous_cols <- c('esp_vida_nsc', 'freq_pre_esc', 'freq_fund', 'freq_med', 'pib_pc')
base_extpob_numeric[continuous_cols] <- lapply(base_extpob_numeric[continuous_cols], function(x) round(x, 2))

# # Exporta a base
# write_xlsx(base_extpob_alt, "base_extpob_alt.xlsx")
# ------------- Analise exploratoria ------------------------------------------


## Análise de medidas de tendencia central ##
# Calcular as medidas de tendência central e dispersão
medidas <- base_extpob_numeric %>%
  summarise_all(list(
    media = mean,
    mediana = median,
    desvio_padrao = sd,
    Q1 = ~ quantile(., 0.25),
    Q3 = ~ quantile(., 0.75)
  ))

# Transpor a tabela para melhor visualização
medidas_t <- t(medidas)
colnames(medidas_t) <- names(base_extpob_numeric)
medidas_t <- as.data.frame(medidas_t)
medidas_t$Medida <- rownames(medidas_t)
medidas_t <- medidas_t %>% relocate(Medida, .before = everything())


# Médias

# perc_oc_agro_media                     perc_oc_agro_media    38.18
# perc_oc_comerc_media                 perc_oc_comerc_media    11.43
# perc_oc_serv_media                     perc_oc_serv_media    31.62
# esp_vida_nsc_media                     esp_vida_nsc_media    70.67
# pop_rural_media                           pop_rural_media 11570.44
# raz_dep_media                               raz_dep_media    56.61
# tx_anaf_media                               tx_anaf_media    27.28
# freq_pre_esc_media                     freq_pre_esc_media    71.93
# freq_fund_media                           freq_fund_media   112.89
# freq_med_media                             freq_med_media    65.44
# pib_pc_media                                 pib_pc_media   267.63
# perc_ext_pob_media                     perc_ext_pob_media    23.47

# Desvio padrão
sapply(base_extpob_alt, sd, na.rm = TRUE)

# Variáveis com alto desvio padrão: pop_rural (8026.416192) e pib_pc (62.801544) têm desvios padrão elevados,
# indicando alta variabilidade nos valores dessas variáveis.
# Variáveis com desvio padrão moderado: perc_oc_agro (12.653409), freq_pre_esc (16.782602), e freq_med (10.671560)
# apresentam desvios padrão moderados, sugerindo variação considerável, mas não extrema.
# Variáveis com baixo desvio padrão: perc_oc_comerc (3.375366), perc_oc_serv (5.523187), esp_vida_nsc (1.288314),
# raz_dep (5.305458), tx_anaf (5.342230), freq_fund (4.869921), e perc_ext_pob (8.659658) têm desvios padrão menores,
# indicando menor variação nos valores dessas variáveis.

## Análise de outliers ##

# Teste de Grubbs 
grubbs_results <- apply(base_extpob_numeric, 2, function(x) grubbs.test(x))

# Exibindo os resultados
grubbs_results

# Resumo dos resultados

# Outliers: com p-valor menor que 0.05, dessa forma rejeitando a hipotese nula portanto
# sao outliers de fato:
# - perc_oc_comerc: 27.38
# - perc_oc_serv: 51.55
# - pop_rural: 49156
# - tx_anaf: 6.94
# - freq_fund: 136.07
# - pib_pc: 846.36

# [[Verificar depois a qual municipio sao os dados outlier e testar fazer resultado sem eles]]

# Transforma a base para formato long
numericas_long <- base_extpob_numeric %>%
  pivot_longer(cols = everything(), names_to = "variavel", values_to = "valor")


## Análise de distribuição ##

# Histograma e KDE para cada variável numérica
ggplot(numericas_long, aes(x = valor)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "lightblue", color = "black") +
  geom_density(color = "red") +
  facet_wrap(~ variavel, scales = "free_x") +
  theme_minimal()

## esp_vida_nsc (Expectativa de Vida ao Nascer):
  
# A distribuição é aproximadamente normal com um pico em torno de 71 anos.
# A densidade diminui dos dois lados do pico, indicando menos variabilidade em valores extremos.

# freq_fund (Frequência no Ensino Fundamental):
   
# A distribuição é levemente assimétrica para a direita, com um pico em torno de 112.
# Há uma menor frequência de valores muito baixos ou muito altos.

# freq_med (Frequência no Ensino Médio):
 
# A distribuição é aproximadamente normal, centrada em torno de 63.
# A densidade é bem distribuída com um leve aumento na cauda direita.

# freq_pre_esc (Frequência na Pré-Escola):

# A distribuição é bimodal, com picos em torno de 65 e 85.
# Há uma menor frequência de valores extremos.

# perc_ext_pob (Percentual de Extrema Pobreza):
 
# A distribuição é aproximadamente normal com um pico em torno de 25.
# A densidade é distribuída simetricamente ao redor do pico.

# perc_oc_agro (Percentual de Ocupação na Agricultura):
 
# A distribuição é levemente assimétrica para a direita, com um pico em torno de 20.
# Há uma menor frequência de valores muito altos.

# perc_oc_comerc (Percentual de Ocupação no Comércio):
  
# A distribuição é aproximadamente normal com um pico em torno de 10.
# A densidade diminui dos dois lados do pico.

# perc_oc_serv (Percentual de Ocupação nos Serviços):

# A distribuição é aproximadamente normal com um pico em torno de 30.
# A densidade é bem distribuída com menos valores extremos.

# pib_pc (PIB per capita):

# A distribuição é assimétrica para a direita, com a maioria dos valores concentrados abaixo de 1000.
# Há alguns valores extremos muito altos, indicando desigualdade.

# pop_rural (População Rural):

# A distribuição é extremamente assimétrica para a direita.
# A maioria dos valores está concentrada abaixo de 50.000, mas há valores extremos muito altos.

# raz_dep (Razão de Dependência):
# A distribuição é aproximadamente normal com um pico em torno de 55.
# A densidade diminui dos dois lados do pico, indicando variabilidade em valores extremos.

# tx_anaf (Taxa de Analfabetismo):

# A distribuição é aproximadamente normal com um pico em torno de 25.
# A densidade diminui dos dois lados do pico.


# Scatterplot de duas variáveis (exemplo)
ggplot(base_extpob_numeric, aes(x = base_extpob_numeric[[12]], y = base_extpob_numeric[[11]])) +
  geom_point(size = 3, alpha = 0.6, color = "blue") +  # Ajuste do tamanho e transparência dos pontos
  geom_smooth(method = "lm", se = FALSE, color = "red", linetype = "dashed") +  # Adicionar linha de tendência
  theme_minimal() +
  labs(
    title = "Relação entre Variáveis",
    x = names(base_extpob_numeric)[12], 
    y = names(base_extpob_numeric)[11]
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12),
    axis.title.y = element_text(size = 12)
  )
# Pairplot para visualizar relações entre múltiplas variáveis e outliers
ggpairs(base_extpob_numeric)

# Análise de correlação entre variáveis

# Selecionando apenas as colunas numéricas
numericas <- base_extpob_alt %>%
  select(where(is.numeric))

# Calculando a matriz de correlação
matriz_cor <- cor(numericas, use = "complete.obs")

# Ajustando o corrplot
corrplot(matriz_cor, method = "color", type = "upper", tl.col = "black", tl.srt = 45, 
         tl.cex = 0.8, addCoef.col = "black", number.cex = 0.7, mar = c(0,0,2,0))

# Outra forma de visualização das correlações
chart.Correlation(base_extpob_numeric, histogram = TRUE, pch = 19)

# Interpretacao das correlacoes

## 1 - Correlacacoes positivas

## tx_anaf e raz_dep
# Correlacao entre as duas variaveis no patamar de 0.74, indicando assim uma forte correlacao.
# Em outras palavras, a medida que a taxa de analfabetismo aumenta, a razao de dependência
# tambem tende a aumentar. Entao municipios e regioes com maiores taxas de analfabetismo tbm tem maior razao
# de dependencia

## perc_oc_agro e tx_anaf
# Correlacao entre essas variaveis foi no patamar de 0.74 tambem, indicando uma forte correlacao.
# Em outras palavras, o percentual de ocupados no setor agropecuario  demonstra grande influência
# em uma maior taxa de analfabetismo. Creio que isso tenha a ver com o fato do trabalho rural haver
# maior concentracao de mao de obra menos especializada.

## perc_ext_pob e tx_anaf
# Correlacao entre essas variaveis demonstrou um valor de 0.79, ou seja, a taxa de analfabetismo tende
# a aumentar quando o percentual de pessoas em extrema pobreza aumenta.

## perc_ext_pob e raz_dep
# Outro par de variaveis que demonstrou altissima correlacao que um maior percentual de pessoas em extrema pobreza
#  está associada a uma maior razão de dependencia.

## 2 - Correlacoes negativas

## perc_ext_pob e pib_pc
# com uma correlacao de -0.8 demonstrando forte relacao, indicando que a medida que o pib per capita aumenta o percentual de pessoas em extrema
# pobreza tende a diminuir consideravelmente.

## perc_oc_comerc e perc_oc_agro
# correlacao negativamente moderada com -0.59, sao duas variaveis em sentidos opostos entao ísso indica tbm na correlacao que percentual de ocupacao
# no setor agropecuario tende a diminuir a medida que o percentual de ocupacao do setor comercial aumenta.

## esp_vida_nsc e perc_oc_agro
# correlacao negativa moderada de -0.44, indicando que ha uma relacao inversa, ou seja, a esperanca de vida ao nascer tende a aumentar com
# um menor percentual de ocupacao no setor agropecuario. Ou seja, pode denotar que regioes mais dependende do setor agropecuario tendem a ter
# menos esperanca de vida ao nascer nos municipios cearenses.

## pib_pc e raz_dep
# correlacao negativa moderadamente forte de -0.65, indicando que a razao de dependência diminui a medida que o pib per capita aumenta.

## pib_pc e tx_anaf
# Correlacao negativa moderadamente forte de -0.73, indicativo que a medida que pib per capita aumenta a taxa de analfabetismo diminui.

# tx_anaf e esp_vida_nsc
# correlacao negativa relativamente forte de -0.47, denotando uma possivel relacao. Onde, municipios com maiores taxas de analfabetismo
# tendem a ter menor esperanca de vida ao nascer.



# remove outlier
base_extpob_alt <- base_extpob_alt [-59,]

## Modelo de regressao

# Estima por modelo de regressão linear
model_ext <- lm(log(perc_ext_pob) ~ log(pop_rural) + log(raz_dep) + log(tx_anaf) + log(pib_pc) + log(esp_vida_nsc) + log(perc_oc_agro) +
              log(perc_oc_comerc) + log(perc_oc_serv) + log(freq_pre_esc) + log(freq_fund) + log(freq_med), data = base_extpob_alt)


# Resumo dos resultados da regressão
summary(model_ext)

# Plota os resultados em tabela
stargazer(model_ext, title = "Resultados da Regressão", column.labels = "model_ext", align = T, type = "text")


# ----------- Testes diagnósticos e análise dos resíduos ---------------------

# Cálculo dos resíduos
residuos <- resid(model_ext)

# Histograma dos resíduos
ggplot(data.frame(residuos = residuos), aes(x = residuos)) +
  geom_histogram(binwidth = 0.5, fill = "lightblue", color = "black") +
  labs(title = "Histograma dos Resíduos", x = "Resíduos", y = "Frequência")

# Análise de outliers
plot(model_ext)
qqPlot(model_ext)

# Grafico de residuals vs leverage
# Possivel notar qque por meio desse grafico observacoes como a 59, 69 e 169
# foram um pouco fora da curva, sendo necessario uma analise com calma posteriormente
# visando verificar a robustez e precisão das analises.

# Grafico de residuals vs fitted
# novamente a observacao 59 demonstrando nao estar adequadamente ajustada para o modelo
# mas ja se era esperado dado que é referente a capital do estado. (possivelmente necessario remover)

# Grafico Normal Q-Q
# Por meio do grafico podemos observar que os residuos dos dados sao distruibos normal em sua maioria, exceto
# por alguns valores nas caldas ( obs: 73, 69 e 59)

# Grafico Scale - Location
# Ë possivel notar qque a maioria dos resíduos do modelo tem variancia constante, exceto por alguns outliers

# Residuals vs Leverage
# demonstra necessidade de verificar obs 59.

# Teste de confirmação de outliers
outlierTest(model_ext)

# Esse teste confirma a observacao 59 como outlier significativo, portanto faremos a remocao

# Teste de normalidade da distribuição
shapiro.test(residuals(model_ext))

# p-valor > 0.05 portanto nao rejeitamos a hipotese nula de normalidade da distruicao

# Teste de heterocedasticidade
bptest(model_ext)
# p-valor > 0.05 portanto nao reijeitamos a hipotese nula de homocedasticidade ( variancia constante )

# Teste de autocorrelação
dwtest(model_ext)

# p-valor > 0.05 portanto nao rejeitamos a hipotese nula de que nao ha autocorrelacao.

# Teste de multicolinearidade
vid_lm <- vif(model_ext)
print(vid_lm)

# Analisando os resultados do VIF podemos notar que todos os resultados sao abaixos de 5, ou seja,
# muito inferiores a 10. Portanto, nao temos problema com multicolinearidade no modelo.

# Teste de Jarque-Bera
residuos <- resid(model_ext)
resultado_jb <- jarque.bera.test(residuos)
print(resultado_jb)

# De acordo com o resultado encontrado vemos qqque o p-valor > 0.05, portanto nao rejeitamos a hipotese
# nula de que ha normalidade da distribuicao mais uma vez agora por pouco teste.

#  -------------- Interpretacao dos resultados do modelo --------------------

## Variaveis individualmente em relacao a variavel y

# Variveis significativas:

# 1 - pop rural: 0.072, p < 0.01
# Um aumento de 1% na população rural está associado a um aumento de 0.072% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

# 2 - raz_dep: 0.823, p < 0.01
#  Um aumento de 1% na razão de dependência está associado a um aumento de 0.823% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

# 3 - tx_anaf: 0.515, p < 0.01
# Um aumento de 1% na taxa de analfabetismo está associado a um aumento de 0.515% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

# 4 - pib_pc: -0.987, p < 0.01
# Um aumento de 1% no PIB per capita está associado a uma diminuição de 0.987% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

# 5 - perc_oc_agro: 0.194, p < 0.01
# Um aumento de 1% na percentagem de ocupação no setor agropecuário está associado a um aumento de 0.194% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

# 6 - perc_oc_serv: 0.239, p < 0.01
# Um aumento de 1% na percentagem de ocupação no setor de serviços está associado a um aumento de 0.239% na percentagem de extrema pobreza, mantendo outras variáveis constantes.

 
# Variaveis nao significativas:

# 1 - esp_vida_nsc: -0.141, p > 0.1
# Sem  efeito significativo na percentual de pessoas em extrema pobreza.

# 2 - perc_oc_comerc: 0.064, p > 0.1
# Sem  efeito significativo na percentual de pessoas em extrema pobreza.

# 3 - freq_pre_esc: -0.051, p > 0.1
# Sem  efeito significativo na percentual de pessoas em extrema pobreza.

# 4 - freq_fund:-0.011, p > 0.1
# Sem  efeito significativo na percentual de pessoas em extrema pobreza.

# 5 - freq_med: -0.011, p > 0.1
# Sem  efeito significativo na percentual de pessoas em extrema pobreza.

# intercepto: 2.388, p > 0.1
# sem significancia

## Interpretacao geral:

# - O modelo de regressão log-log apresentou um ajuste muito bom aos dados, com um R² ajustado de 0.869,
#  indicando que aproximadamente 87,88% da variação em log(perc_ext_pob) é explicada pelas variáveis independentes do modelo.

# - As variáveis mais significativas (p < 0.01) que afetam a percentagem de extrema pobreza são log(pop_rural), log(raz_dep),
#  log(tx_anaf), log(pib_pc), log(perc_oc_agro) e log(perc_oc_serv). Isso sugere que a população rural, a razão de dependência,
#  a taxa de analfabetismo, o PIB per capita, a ocupação no setor agropecuário e a ocupação no setor de serviços são fatores
#  cruciais para a determinação da extrema pobreza.

# - Algumas variáveis, como a esperança de vida ao nascer, a percentagem de ocupação no comércio, a frequência pré-escolar,
#  a frequência no ensino fundamental e a frequência no ensino médio, não mostraram significância estatística, indicando que,
#  dentro deste modelo, esses fatores não têm um impacto significativo na percentagem de extrema pobreza.


## Insights e implicacoes em politicas publicas

# Alguns direcionamentos que podemos inferir é a necessidade de politicas rurais de desenvolvimento, dado a relaçao encontrada
# entre populacao rural e o percentual de pessoas em extrema pobreza, políticas focadas nesse grupo podem trazer melhorias de bem estar
# no campo, tendo em vista a diminuicao da extrema pobreza nos municipios do estado do ceará. No entanto, quando falamos sobre educação
# foi possivel notar a extrema necessidade da boas taxas de alfabetizacao podendo ter efeitos muito positivos sobre o percentual de pessoas
# em extrema pobreza, mas é interessante ressaltar que apenas a presenca alta em todas as etapas estudantis nao demonstraram ter nenhuma
# efeito significativo na reducao da extrema pobreza, o que pode indicar por um lado onde a qualidade da educacao ofertada e a  oferta de oportunidade
# de educacao  e manuntencao de boas taxas alfabetizacao possam surtir efeitos positivos na reducao da extrema pobreza. Em relacao ao desenvolvimento
# economico podemos evidenciar o forte impacto do crescimento economico e aumento do pib per capita na reducao da extrema pobreza, mas claro tambem
# dando mesma importancia na distribuicao mais equitaria dos recursos gerados em excedente. Acerca dos setores de emprego analisados demonstrou uma necessidade
# da geracao de empregos de qualidade e foco em empregabilidade formal, dado que possa ocorrer o contrario no campo e regioes mais ruralizadas e menos populosas,
# entao o desenvolvimento desses setores possam gerar mais empregos, mas tambem reduzir a extrema pobreza.





