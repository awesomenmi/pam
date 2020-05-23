#!/bin/bash

if [ $(date +%a) = "Sun" ] && [ $(date +%a) = "Sat" ]; then
  if [ $PAM_GROUP = "admins" ]; then
        exit 0
     else
	exit 1
  fi
fi

E0F
