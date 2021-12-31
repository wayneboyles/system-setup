#!/bin/bash



# delete all existing rules
iptables -F

# set default chain policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# loopback
iptables -A INPUT -i lo -j ACCEPT

# accept related or established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# block scanners
iptables -A INPUT -i eth0 -j DROP -p udp --dport 5060 -m string --string "friendly-scanner" --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p tcp --dport 5060 -m string --string "friendly-scanner" --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p udp --dport 5060 -m string --string "sipcli/" --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p tcp --dport 5060 -m string --string "sipcli/" --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p udp --dport 5060 -m string --string "VaxSIPUserAgent/" --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p tcp --dport 5060 -m string --string "VaxSIPUserAgent/" --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p udp --dport 5060 -m string --string "pplsip" --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p tcp --dport 5060 -m string --string "pplsip" --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p udp --dport 5060 -m string --string "system " --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p tcp --dport 5060 -m string --string "system " --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p udp --dport 5060 -m string --string "exec." --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p tcp --dport 5060 -m string --string "exec." --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p udp --dport 5060 -m string --string "multipart/mixed;boundary" --algo bm --icase
iptables -A INPUT -i eth0 -j DROP -p tcp --dport 5060 -m string --string "multipart/mixed;boundary" --algo bm --icase

# allow ssh
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT

# accept pgsql from specific networks
iptables -A INPUT -i eth0 -p tcp -s 10.91.234.0/24 --dport 5432 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -s 10.98.234.0/24 --dport 5432 -m state --state NEW,ESTABLISHED -j ACCEPT

# msrp
iptables -A INPUT -i eth0 -p udp --dport 2855:2856 -m state --state NEW,ESTABLISHED -j ACCEPT

# stun
iptables -A INPUT -i eth0 -p udp --dport 3478:3479 -m state --state NEW,ESTABLISHED -j ACCEPT

# mlp protocol server
iptables -A INPUT -i eth0 -p tcp --dport 5002 -m state --state NEW,ESTABLISHED -j ACCEPT

# neighborhood service
iptables -A INPUT -i eth0 -p udp --dport 5003 -m state --state NEW,ESTABLISHED -j ACCEPT

# sip
iptables -A INPUT -i eth0 -p udp --dport 5060 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 5060 -m state --state NEW,ESTABLISHED -j ACCEPT

# sip trunks
iptables -A INPUT -i eth0 -p udp --dport 5160 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 5160 -m state --state NEW,ESTABLISHED -j ACCEPT

# rtp
iptables -A INPUT -i eth0 -p udp --dport 16384:32768 -j ACCEPT

# webrtc
iptables -A INPUT -i eth0 -p tcp --dport 5066 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 7443 -m state --state NEW,ESTABLISHED -j ACCEPT

# verto
iptables -A INPUT -i eth0 -p tcp --dport 8081:8082 -m state --state NEW,ESTABLISHED -j ACCEPT

# rtp qos
iptables -A OUTPUT -t mangle -p udp -m udp --sport 16384:32768 -j DSCP --set-dscp-class ef

# sip qos for udp
iptables -A OUTPUT -t mangle -p udp -m udp --sport 5060 -j DSCP --set-dscp-class cs3
iptables -A OUTPUT -t mangle -p udp -m udp --sport 5061 -j DSCP --set-dscp-class cs3
iptables -A OUTPUT -t mangle -p udp -m udp --dport 5060 -j DSCP --set-dscp-class cs3
iptables -A OUTPUT -t mangle -p udp -m udp --dport 5061 -j DSCP --set-dscp-class cs3

# sip qos for tcp
iptables -A OUTPUT -t mangle -p tcp --sport 5060 -j DSCP --set-dscp-class cs3
iptables -A OUTPUT -t mangle -p tcp --sport 5061 -j DSCP --set-dscp-class cs3
iptables -A OUTPUT -t mangle -p tcp --dport 5060 -j DSCP --set-dscp-class cs3
iptables -A OUTPUT -t mangle -p tcp --dport 5061 -j DSCP --set-dscp-class cs3

# save
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

shutdown -r now