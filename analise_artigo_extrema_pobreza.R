###-------------------- Analise da Extrema Pobreza -----------------------------
### Gera resultados do modelo de regressao da extrema pobreza
### AUTOR: ADRIANO NETO, EM 28/01/2022, Alterado em 09/06/2024

### OBJETIVO: 

# Limpa o ambiente
rm(list = ls())

# Carrega/instala os pacotes necessários
pacotes = c(
  "tidyverse", "readxl", "dplyr", "stringr", "xgboost",
  "wooldridge", "lmtest", "faraway", "stargazer", "randomForest",
  "ggplot2", "tseries", "car", "corrplot", "PerformanceAnalytics", 
  "caret", "rmarkdown", "glmnet", "neuralnet", "e1071", "gbm", "rpart",
  "httr", "jsonlite"
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

# Verifica a quantidade de dados ausentes
missing_data <- sapply(base_extpob, function(x) sum(is.na(x)))
print(missing_data)

# Remover linhas com dados ausentes (pode-se considerar imputação de dados como alternativa)
base_extpob <- na.omit(base_extpob)

# Alternativamente, pode-se fazer a imputação dos valores ausentes
# base_extpob_clean <- base_extpob
# base_extpob_clean[is.na(base_extpob_clean)] <- median(base_extpob_clean, na.rm = TRUE)

# Seleciona apenas colunas numéricas para visualização de correlação
numeric_cols <- sapply(base_extpob, is.numeric)
base_extpob_numeric <- base_extpob[, numeric_cols]



# ------------- Analise exploratoria ------------------------------------------
# Correlacaao entre variáveis 
corrplot(cor(base_extpob_numeric), method = "circle")


## Modelo de regressao

# Estima por modelo de regressão linear
reg_1 <- lm(log(PER_EXTPOBRE_2010) ~ log(POP_R2010) + log(RDEP_2010) + log(TX_ANALF2010) + log(RPC_2010), data = base_extpob)

# Resumo dos resultados da regressão
summary(reg_1)

# Plota os resultados em tabela
stargazer(reg_1, title = "Resultados da Regressão", column.labels = "reg_1", align = T, type = "text")




# ----------- Testes diagnósticos e análise dos resíduos ---------------------

# Cálculo dos resíduos
residuos <- resid(reg_1)

# Histograma dos resíduos
ggplot(data.frame(residuos = residuos), aes(x = residuos)) +
  geom_histogram(binwidth = 0.5, fill = "lightblue", color = "black") +
  labs(title = "Histograma dos Resíduos", x = "Resíduos", y = "Frequência")

# Análise de outliers
plot(reg_1)
qqPlot(reg_1)

# Teste de confirmação de outliers
outlierTest(reg_1)

# Teste de normalidade da distribuição
shapiro.test(residuals(reg_1))

# Teste de heterocedasticidade
lmtest::bptest(reg_1)

# Teste de autocorrelação
dwtest(reg_1)

# Teste de multicolinearidade
vif_reg_1 <- vif(reg_1)
print(vif_reg_1)


# Teste de Jarque-Bera
residuos <- resid(reg_1)
resultado_jb <- jarque.bera.test(residuos)
print(resultado_jb)

# Desvio padrão
sapply(base_extpob, sd, na.rm = TRUE)

# ------------- Visualização dos resíduos e avaliação de outliers--------------


# Selecionar apenas as colunas numéricas
numeric_cols <- sapply(base_extpob, is.numeric)
base_extpob_numeric <- base_extpob[, numeric_cols]

# Matriz de dispersão
pairs(base_extpob_numeric, main = "Matriz de Dispersão")

# Mapa de correlação
corr_matrix <- cor(base_extpob_numeric, use = "complete.obs")
corrplot(corr_matrix, method = "number", type = "upper")

# Outra forma de visualização das correlações
chart.Correlation(base_extpob_numeric, histogram = TRUE, pch = 19)


# -------------------- Separando dados de treinamento(validar/ajustar) e teste --------------------------

# Separa os dados em conjuntos de treino e teste
set.seed(123)
index <- createDataPartition(base_extpob$PER_EXTPOBRE_2010, p = 0.8, list = FALSE)
train_data <- base_extpob[index, ]
test_data <- base_extpob[-index, ]

# Reestimando o modelo com dados de treinamento
reg_1_train <- lm(log(PER_EXTPOBRE_2010) ~ log(POP_R2010) + log(RDEP_2010) + log(TX_ANALF2010) + log(RPC_2010), data = train_data)
summary(reg_1_train)

## Resultados da regressao de treino 

# Plota os resultados em tabela
stargazer(reg_1_train, title = "Resultados da Regressão", column.labels = "reg_1_train", align = T, type = "text")

# Predição e avaliação o modelo final no conjunto de treino
predictions <- predict(reg_1_train, newdata = train_data)

mse <- mean((exp(predictions) - train_data$PER_EXTPOBRE_2010)^2)
print(paste("Mean Squared Error no conjunto de teste: ", mse))

rmse <- sqrt(mean((predictions - log(train_data$PER_EXTPOBRE_2010))^2))
print(paste("Root Mean Squared Error no conjunto de teste: ", rmse))

# Os resultados mostrados estão bons, com MSE = 12.019 e RMSE = 0.159
# Note que: Quanto menor RMSE ou MSE, melhor ajuste do modelo.
# MSE em se distancia do valores medioos em 12.019 unidades
# RMSE indica uma diferença dos valores previstos em aprox 0.159 em escala log


# Acho que preciso de uma amostra melhor pra poder fazer esses testes
# Visualizar os resultados com cores diferentes
ggplot(data.frame(Real = train_data$PER_EXTPOBRE_2010, Predito = exp(predictions)), aes(x = Real, y = Predito)) +
  geom_point(aes(color = "Predito")) +  # Cor para os valores preditos
  geom_point(aes(x = Real, y = Real, color = "Real")) +  # Cor para os valores reais
  geom_abline(intercept = 0, slope = 1, color = "red") +  # Linha de referência
  labs(title = "Valores Reais vs. Preditos", x = "Valores Reais", y = "Valores Preditos") +
  scale_color_manual(name = "Legenda", values = c("Real" = "blue", "Predito" = "green")) +
  theme_minimal()

# Bootstrap para estimar a precisão dos coeficientes
boot_reg <- boot(data = train_data, statistic = function(data, indices) {
  data <- data[indices, ]
  fit <- lm(log(PER_EXTPOBRE_2010) ~ log(POP_R2010) + log(RDEP_2010) + 
              log(TX_ANALF2010) + log(RPC_2010), data = data)
  return(coef(fit))
}, R = 1000)
boot.ci(boot_reg, type = "bca")

# Validação Cruzada do modelo na base de treinamento
set.seed(123)

# Definir o método de treinamento
train_control <- trainControl(method = "cv", number = 10)

# Treinar o modelo usando validação cruzada
reg_cv <- train(log(PER_EXTPOBRE_2010) ~ log(POP_R2010) + log(RDEP_2010) + log(TX_ANALF2010) + log(RPC_2010),
                data = train_data, method = "lm", trControl = train_control)

# Resultados da validação cruzada
print(reg_cv)

# Métricas de performance
results <- reg_cv$results
print(results)

# O RMSE e MAE tem valores baixos entao sugerem que o modelo tem bom desempenho de previsao
# R² é alto entao tem uma capacidade explicativa boa
# o RMSESD, RsquaredSD e MAESD tem valores baixos oque indica um modelo estavel e robusto
nn_model <- nnet(PER_EXTPOBRE_2010 ~ ., data = train_data, size = 5, linout = TRUE)

# Resultados (apenas um teste curioso, nao levar a serio)
# Pesos: 756 (parece ser o número de pesos na sua rede neural).
# Valor Inicial: 91230.649429 (Isso pode ser o valor da função de perda no início do treinamento).
# Valor Final: 10912.397703 (O valor da função de perda após o treinamento, que é muito menor que o inicial).
# Convergiu: Isso indica que o treinamento convergiu para um valor aceitável.

# -------------------- Implementa Técnicas de regularização Ridge e Lasso regression -----------

# Preparar os dados
X <- model.matrix(log(PER_EXTPOBRE_2010) ~ log(POP_R2010) + log(RDEP_2010) + log(TX_ANALF2010) + log(RPC_2010), train_data)[, -1]
y <- log(train_data$PER_EXTPOBRE_2010)

# Definir grid de lambda
lambda_grid <- 10^seq(10, -2, length = 100)

# Ridge Regression
set.seed(123)
ridge_cv <- cv.glmnet(X, y, alpha = 0, lambda = lambda_grid)
best_lambda_ridge <- ridge_cv$lambda.min
ridge_model <- glmnet(X, y, alpha = 0, lambda = best_lambda_ridge)

# Lasso Regression
set.seed(123)
lasso_cv <- cv.glmnet(X, y, alpha = 1, lambda = lambda_grid)
best_lambda_lasso <- lasso_cv$lambda.min
lasso_model <- glmnet(X, y, alpha = 1, lambda = best_lambda_lasso)

# Resultados
print(ridge_model)
print(lasso_model)

# -------------------  Análise de resíduos e avaliação de outliers ---------------

# Calcular os valores preditos e resíduos para o modelo Ridge
ridge_pred <- predict(ridge_model, newx = X)
ridge_residuals <- y - ridge_pred

# Calcular os valores preditos e resíduos para o modelo Lasso
lasso_pred <- predict(lasso_model, newx = X)
lasso_residuals <- y - lasso_pred

# Histograma dos resíduos do modelo Ridge
hist(ridge_residuals, breaks = 20, main = "Histograma dos Resíduos do Modelo Ridge", xlab = "Resíduos", col = "lightblue")

# Histograma dos resíduos do modelo Lasso
hist(lasso_residuals, breaks = 20, main = "Histograma dos Resíduos do Modelo Lasso", xlab = "Resíduos", col = "lightblue")

# Q-Q plot dos resíduos do modelo Ridge
qqnorm(ridge_residuals, main = "Q-Q Plot dos Resíduos do Modelo Ridge")
qqline(ridge_residuals, col = "red")

# Q-Q plot dos resíduos do modelo Lasso
qqnorm(lasso_residuals, main = "Q-Q Plot dos Resíduos do Modelo Lasso")
qqline(lasso_residuals, col = "red")

#  -------------Teste de outliers usando o modelo de regressão linear --------------
lm_model <- lm(log(PER_EXTPOBRE_2010) ~ log(POP_R2010) + log(RDEP_2010) + log(TX_ANALF2010) + log(RPC_2010), data = train_data)
outlierTest(lm_model)

# Plot dos resíduos contra os valores ajustados
plot(lm_model$fitted.values, lm_model$residuals,
     xlab = "Valores Ajustados",
     ylab = "Resíduos",
     main = "Resíduos vs. Valores Ajustados")
abline(h = 0, col = "red")

# Histograma dos resíduos
hist(lm_model$residuals, breaks = 20, main = "Histograma dos Resíduos", xlab = "Resíduos", col = "lightblue")

# Q-Q plot dos resíduos
qqnorm(lm_model$residuals, main = "Q-Q Plot dos Resíduos")
qqline(lm_model$residuals, col = "red")

# Teste de homocedasticidade (Breusch-Pagan)
bptest(lm_model)

# Teste de normalidade (Shapiro-Wilk)
shapiro.test(lm_model$residuals)

