# Based on Ubuntu                                                                                                                                                                                            
############################################################                                                                                                                                                 
                                                                                                                                                                                                             
# Set the base image to Ubuntu                                                                                                                                                                               
FROM ubuntu                                                                                                                                                                                                  
                                                                                                                                                                                                             
# File Author / Maintainer                                                                                                                                                                                   
MAINTAINER Frank Wagener <docker@dapor.de>                                                                                                                                                                   
                                                                                                                                                                                                             
                                                                                                                                                                                                             
# Update the repository sources list                                                                                                                                                                         
RUN apt-get update -q                                                                                                                                                                                        
RUN apt-get upgrade -qy                                                                                                                                                                                      
RUN apt-get install lsof sysstat wget  -qy                                                                                                                                                                   
RUN echo "wget -O kerio-connect-linux-64bit.deb http://cdn.kerio.com/dwn/connect/connect-8.5.0-4416/kerio-connect-8.5.0-4416-linux-amd64.deb" > dl.sh                                                                                                                          
RUN chmod +x dl.sh                                                                                                                                                                                           
RUN ./dl.sh                                                                                                                                                                                                  
################## BEGIN INSTALLATION #########################                                                                                                                                              
RUN dpkg -i kerio-connect-linux-64bit.deb    
RUN echo "/etc/init.d/kerio-connect stop" >> /kerio-restore.sh 
RUN echo "/opt/kerio/mailserver/kmsrecover /backup/" >> /kerio-restore.sh                                                                                                                                    
RUN echo "/opt/kerio/mailserver/mailserver /opt/kerio/mailserver" >> /run_kerio.sh          
RUN locale-gen en_US.utf8
RUN useradd docker -d /home/docker -g users -G sudo -m                                                                                                                    
RUN echo docker:test123 | chpasswd
COPY sleep.sh /tmp/                                                                                                                                                                                          
RUN chmod +x /tmp/sleep.sh                                                                                                                                                                                   
RUN echo "/tmp/sleep.sh" >> /run_kerio.sh                                                                                                                                                                    
                                                                                                                                                                                                             
RUN chmod +x /run_kerio.sh                                                                                                                                                                                   
RUN chmod +x /kerio-restore.sh                                                                                                                                                                               
##################### INSTALLATION END #####################                                                                                                                                                 
# Expose the default port  only 4040 is nessecary for admin access                                                                                                                                           
                                                                                                                                                                                                             
EXPOSE 4040  22 25 465 587 110 995 143 993 119 563 389 636 80 443 5222 5223                                                                                                                                     
                                                                                                                                                                                                             
VOLUME /backup                                                                                                                                                                                               
# Set default container command                                                                                                                                                                              
#ENTRYPOINT /opt/kerio/mailserver/mailserver /opt/kerio/mailserver                                                                                                                                           
ENTRYPOINT /run_kerio.sh                                                                                                                                                                                     
