#!/usr/bin/env bash

function handle_kde_settings() {
    echo -ne "
-------------------------------------------------------------------------
                    Handling KDE settings
-------------------------------------------------------------------------
"
    # Set fractional scaling to 125%
    kscreen-doctor output.1.scale.1,25

    # Set adaptive sync to automatic
    kscreen-doctor output.1.vrrpolicy.automatic
}

handle_kde_settings
