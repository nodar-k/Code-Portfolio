#####################################
##  Lab 3 - Part 4 - Ebola Model
##  Nodar Kipshidze
##  P8477
##  February 12, 2022
#####################################

# Load relevant libraries

library(deSolve)
library(ggplot2)
library(gganimate)
library(ggpubr)
library(av)

# Set-up some key parameters

Rn = 2.0

# Areas for row names for easy identification
areas = c("Overall", "Guinea", "Liberia", "Sierra Leone")

# Note the following order
# 1st index = Some rate for overall; # 2nd index = Some rate for Guinea; # 3rd index = Some rate for Liberia; # 4th = Some rate for Sirrea Leone

# Infectious rate
alpha = c((1/10.3),(1/12.6),(1/10.0),(1/10.4))

# Removal rate
gamma = c((1/15.1),(1/16.3),(1/15.7),(1/13.7))

# Fatality rate
mu = c((1/8.2),(1/8.4),(1/8.8), (1/6.8))

# Proportion dying
theta = c(0.704,0.659,0.706,0.734)

# Contact rate
beta=c()
for(i in 1:4){
  beta[i] = c((Rn*(gamma[i]*mu[i]))/alpha[i])
  
}

# Parameters table
parameters_model = data.frame(areas, alpha, gamma, mu, theta, beta)

Ebola=function(t,state,parameters){
  with(as.list(c(state,parameters)),{
    
    # rate of change
    dS=-beta*S*I/N;
    dE=(beta*S*I/N)-(alpha*E);
    dI=(alpha*E)-(gamma*I*(1-theta))-(mu*I*theta);
    dR=gamma*I*(1-theta);

    # cumulative fatality
    #dcumF=mu*I*theta;
    
    # return the rate of change
    list(c(dS,dE, dI, dR))  
  }) # end with(as.list...)
}

# Initial parameters
# 100,000 starting population
# 10 initial infections at t=0


#1st Run - Overall Epidemic
times=0:(365*2)
N=1e5; E0=0; I0=10; S=N-E0-I0; R0=0;
state=c(S=S0,E=E0,I=I0,R=R0);

stateSEIR=c(S=S0,E=E0,I=I0,R=R0);

paramSEIR=c(beta=parameters_model[1,6],alpha=parameters_model[1,2],gamma=parameters_model[1,3], mu=parameters_model[1,4], theta=parameters_model[1,5]); 
simSEIR=ode(y=stateSEIR,times=times,func=Ebola,parms=paramSEIR) # run SEIR
Overall=as.data.frame(simSEIR)
deaths = N-Overall['S']-Overall['E']-Overall['I']-Overall['R']
Overall = cbind(Overall,deaths)
colnames(Overall) = c("time","S","E","I","R","deaths")

## 2nd Run - Guinea
times=0:(365*2)
N=1e5; E0=0; I0=10; S=N-E0-I0; R0=0;
state=c(S=S0,E=E0,I=I0,R=R0);

stateSEIR=c(S=S0,E=E0,I=I0,R=R0);

paramSEIR=c(beta=parameters_model[2,6],alpha=parameters_model[2,2],gamma=parameters_model[2,3], mu=parameters_model[2,4], theta=parameters_model[2,5]); 
simSEIR=ode(y=stateSEIR,times=times,func=Ebola,parms=paramSEIR) # run SEIR
Guinea=as.data.frame(simSEIR)
deaths = N-Guinea['S']-Guinea['E']-Guinea['I']-Guinea['R']
Guinea = cbind(Guinea,deaths)
colnames(Guinea) = c("time","S","E","I","R","deaths")

## 3rd Run - For Liberia
times=0:(365*2)
N=1e5; E0=0; I0=10; S=N-E0-I0; R0=0;
state=c(S=S0,E=E0,I=I0,R=R0);

stateSEIR=c(S=S0,E=E0,I=I0,R=R0);

paramSEIR=c(beta=parameters_model[3,6],alpha=parameters_model[3,2],gamma=parameters_model[3,3], mu=parameters_model[3,4], theta=parameters_model[3,5]); 
simSEIR=ode(y=stateSEIR,times=times,func=Ebola,parms=paramSEIR) # run SEIR
Liberia=as.data.frame(simSEIR)
deaths = N-Liberia['S']-Liberia['E']-Liberia['I']-Liberia['R']
Liberia = cbind(Liberia,deaths)
colnames(Liberia) = c("time","S","E","I","R","deaths")

## 4th Run - For Sierra Leone
times=0:(365*2)
N=1e5; E0=0; I0=10; S=N-E0-I0; R0=0;
state=c(S=S0,E=E0,I=I0,R=R0);

stateSEIR=c(S=S0,E=E0,I=I0,R=R0);

paramSEIR=c(beta=parameters_model[4,6],alpha=parameters_model[4,2],gamma=parameters_model[4,3], mu=parameters_model[4,4], theta=parameters_model[4,5]); 
simSEIR=ode(y=stateSEIR,times=times,func=Ebola,parms=paramSEIR) # run SEIR
SierraLeone=as.data.frame(simSEIR)
deaths = N-SierraLeone['S']-SierraLeone['E']-SierraLeone['I']-SierraLeone['R']
SierraLeone = cbind(SierraLeone,deaths)
colnames(SierraLeone) = c("time","S","E","I","R","deaths")

## Plotting 

ggplot(Overall, aes(x=time))+
  geom_line(aes(y=S, color="a"), size=1)+
  geom_line(aes(y=E, color="c"), size=0.5, linetype="longdash")+
  geom_line(aes(y=I, color="b"), size=0.5, linetype="longdash")+
  geom_line(aes(y=deaths, color="d"), size=0.5, linetype="longdash")+
    scale_color_manual("States", values = c("a" = "navy", "b" = "magenta", c="green",d="purple"), labels=c("Susceptible", "Exposed","Infected","Fatalities"))+
  scale_x_continuous(limits=c(0,365*2)) +
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position=c(0.85,0.85),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  xlab("") +
  ylab("") +
  labs(title="Overall")

mortality_Overall = ggplot(Overall, aes(x=time))+
  geom_line(aes(y=deaths, color="d"), size=1)+
  scale_x_continuous(limits=c(0,365*2)) +
  scale_y_continuous(limits=c(0,60000)) +
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position="none",
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  ylab("Fatailites (count)") +
  xlab("Time (days)") +
  labs(title="Overall")

mortality_Guinea = ggplot(Guinea, aes(x=time))+
  geom_line(aes(y=deaths, color="d"), size=1)+
  scale_x_continuous(limits=c(0,365*2)) +
  scale_y_continuous(limits=c(0,60000)) +
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position="none",
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  ylab("") +
  xlab("Time (days)") +
  labs(title="Guinea")

mortality_Liberia = ggplot(Liberia, aes(x=time))+
  geom_line(aes(y=deaths, color="d"), size=1)+
  scale_x_continuous(limits=c(0,365*2)) +
  scale_y_continuous(limits=c(0,60000)) +
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position="none",
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  ylab("Fatailites (count)") +
  xlab("Time (days)") +
  labs(title="Liberia")

mortality_SierraLeone = ggplot(SierraLeone, aes(x=time))+
  geom_line(aes(y=deaths, color="d"), size=1)+
  scale_x_continuous(limits=c(0,365*2)) +
  scale_y_continuous(limits=c(0,60000)) +
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position="none",
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  ylab("") +
  xlab("Time (days)") +
  labs(title="Sierra Leone")

ggarrange(mortality_Overall, mortality_Guinea, mortality_Liberia, mortality_SierraLeone, 
          labels = c("A", "B", "C", "D"),
          ncol = 2, nrow = 2,
          common.legend = FALSE)

infec_Overall = ggplot(Overall, aes(x=time))+
  geom_line(aes(y=I), color="blue", size=1)+
  scale_x_continuous(limits=c(0,365*2)) +
  scale_y_continuous(limits=c(0,10000)) +
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position="none",
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  ylab("Infecteds (count)") +
  xlab("") +
  labs(title="Overall")

infec_Guinea = ggplot(Guinea, aes(x=time))+
  geom_line(aes(y=I), color="blue", size=1)+
  scale_x_continuous(limits=c(0,365*2)) +
  scale_y_continuous(limits=c(0,10000)) +
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position="none",
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  ylab("") +
  xlab("") +
  labs(title="Guinea")

infec_Liberia = ggplot(Liberia, aes(x=time))+
  geom_line(aes(y=I), color="blue", size=1)+
  scale_x_continuous(limits=c(0,365*2)) +
  scale_y_continuous(limits=c(0,10000)) +
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position="none",
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  ylab("Infecteds (count)") +
  xlab("Time (days)") +
  labs(title="Liberia")

infec_SierraLeone = ggplot(SierraLeone, aes(x=time))+
  geom_line(aes(y=I), color="blue", size=1)+
  scale_x_continuous(limits=c(0,365*2)) +
  scale_y_continuous(limits=c(0,10000)) +
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position="none",
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  ylab("") +
  xlab("Time (days)") +
  labs(title="Sierra Leone")

ggplot(NULL)+
  geom_line(data=Overall, aes(x=time, y=I, color="a"), size=1) + 
  geom_line(data=Guinea, aes(x=time, y=I, color="b"), size=0.5) + 
  geom_line(data=Liberia, aes(x=time, y=I, color="c"), size=0.5) + 
  geom_line(data=SierraLeone, aes(x=time, y=I, color="d"), size=0.5) + 
  annotate(geom="text", x=340, y=3750, label = "313 days", hjust="left", size=3)+
  annotate(geom="text", x=290, y=5650, label = "270 days", hjust="left", size=3)+
  annotate(geom="text", x=410, y=2915, label = "373 days", hjust="left", size=3)+
  annotate(geom="text", x=220, y=4750, label = "237 days", hjust="right", size=3)+
  scale_x_continuous(limits=c(0,365*2)) +
  scale_y_continuous(limits=c(0,10000)) +
  scale_colour_viridis_d("Countries", labels=c("Overall", "Guinea","Liberia","Sierra Leone"))+
  #scale_color_manual("Countries", values = c(a= "#D16103", b= "#FFDB6D", c="#52854C", d="#293352"), labels=c("Overall", "Guinea","Liberia","Sierra Leone"))+
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position=c(0.85, 0.85),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  ylab("Infecteds per day (count)") +
  xlab("Time (days)") +
  labs(title="Simulating Ebola Epidemic by Countries")

ggplot(NULL)+
  geom_line(data=Overall, aes(x=time, y=deaths, color="a"), size=1) + 
  geom_line(data=Guinea, aes(x=time, y=deaths, color="b"), size=0.5) + 
  geom_line(data=Liberia, aes(x=time, y=deaths, color="c"), size=0.5) + 
  geom_line(data=SierraLeone, aes(x=time, y=deaths, color="d"), size=0.5) + 
  scale_x_continuous(limits=c(0,365*2)) +
  scale_y_continuous(limits=c(0,75000)) +
  scale_colour_viridis_d("Countries", labels=c("Overall", "Guinea","Liberia","Sierra Leone"))+
  #scale_color_manual("Countries", values = c(a= "#D16103", b= "#FFDB6D", c="#52854C", d="#293352"), labels=c("Overall", "Guinea","Liberia","Sierra Leone"))+
  theme_light() +
  theme(text=element_text(size=10,  face="bold"), 
        legend.position=c(0.85, 0.25),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  ylab("Total deaths") +
  xlab("Time (days)") +
  labs(title="Simulating Ebola Epidemic by Countries")

ggarrange(plotlist=list(infec_Overall, infec_Guinea, infec_Liberia, infec_SierraLeone), 
          labels = c("A", "B", "C", "D"),
          col = 2, nrow = 2,
          common.legend = FALSE)
