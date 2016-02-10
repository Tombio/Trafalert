package com.studiowannabe.trafalert.domain.warning;

import lombok.Data;

import java.math.BigDecimal;

/**
 * Created by Tomi on 31/01/16.
 */
public @Data class VisibilityWarning extends Warning {

    private final BigDecimal visibility;

    public VisibilityWarning(final WarningType type, final BigDecimal visibility) {
        super(type);
        this.visibility = visibility;
    }
}
