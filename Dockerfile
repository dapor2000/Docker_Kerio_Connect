# Based on Ubuntu                                                                                                                                                                                            
############################################################                                                                                                                                                 
                                                                                                                                                                                                             
# Set the base image to Ubuntu                                                                                                                                                                               
FROM ubuntu                                                                                                                                                                                                  
                                                                                                                                                                                                             
# File Author / Maintainer                                                                                                                                                                                   
MAINTAINER Frank Wagener <docker@dapor.de>                                                                                                                                                                   
                                                                                                                                                                                                             
                                                                                                                                                                                                             
# Update the repository sources list                                                                                                                                                                         
RUN apt-get update -q                                                                                                                                                                                        
RUN apt-get upgrade -qy                                                                                                                                                                                      
RUN apt-get install lsof sysstat wget openssh-server supervisor -qy                                                                                                                                                                   
RUN echo "wget http://download.kerio.com/dwn/kerio-connect-linux-64bit.deb" > dl.sh                                                                                                                          
RUN chmod +x dl.sh                                                                                                                                                                                           
RUN ./dl.sh                                                                                                                                                                                                  
################## BEGIN INSTALLATION #########################                                                                                                                                              
RUN dpkg -i kerio-connect-linux-64bit.deb                                                                                                                                                                    
RUN ulimit -c unlimited                                                                                                                                                         
RUN ulimit -s 2048                                                                                                                                                             
RUN ulimit -n 10240
RUN echo "/opt/kerio/mailserver/kmsrecover /backup/" >> /kerio-restore.sh                                                                                                       
    
COPY /etc/supervisor/conf.d/supervisord.conf  /etc/supervisor/conf.d/supervisord.conf 
                                                                                                                                                                               
                                                                                                                                                                                                             
RUN chmod +x /kerio-restore.sh                                                                                                                                                                               
##################### INSTALLATION END #####################                                                                                                                                                 
# Expose the default port  only 4040 is nessecary for admin access                                                                                                                                           
                                                                                                                                                                                                             
EXPOSE 4040  25 465 587 110 995 143 993 119 563 389 636 80 443 5222 5223                                                                                                                                     
                                                                                                                                                                                                             
VOLUME /backup          
VOLUME /mailserver/data   
# Set default container command                                                                                                                                                                              
ENTRYPOINT ["/usr/bin/supervisord"]                                                                                                                                                                          
CMD ["-c", "/etc/supervisor/conf.d/supervisord.conf"] 
