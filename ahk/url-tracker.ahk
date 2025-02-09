; tracking parameters
trackingParameters := ["_bta_c", "_bta_tid", "_ga", "_hsenc", "_hsmi", "_ke", "_openstat", "cid", "dm_i", "ef_id", "epik", "fbclid", "gclid", "gclsrc", "gdffi", "gdfms", "gdftrk", "hsa_", "igshid", "matomo_", "mc_", "mkwid", "msclkid", "mtm_", "ns_", "oly_anon_id", "oly_enc_id", "otc", "pcrid", "piwik_", "pk_", "rb_clickid", "redirect_log_mongo_id", "redirect_mongo_id", "ref", "s_kwcid", "sb_referer_host", "scrolla", "soc_src", "soc_trk", "spm", "sr_", "srcid", "stm_", "trk_", "utm_", "vero_", "spm_id_from", "vd_source", "si", "from_search", "from_srp", "qid", "rank", "mbid", "smtyp", "smid", "CMP", "from", "s", "t", "utm_source", "utm_campaign", "utm_medium", "utm_term", "as"]

blacklist := ["WindowTerminal.exe"]

; ctrl-alt-c
^!c::
    WinGet, activeProcess, ProcessName, A
    ; Check if the process is in the blacklist
    for index, process in blacklist {
        if (activeProcess = process) {
            MsgBox, Script disabled for this application!
            return
        }
    }

    clipboard := Clipboard
    cleanedURL := clipboard
    for index, param in trackingParameters {
        cleanedURL := RegExReplace(cleanedURL, "[?&]" param "=[^&]*", "")
    }
    cleanedURL := RegExReplace(cleanedURL, "[?&]$", "")
    Clipboard := cleanedURL
    MsgBox, Cleaned URL: %cleanedURL%
return


