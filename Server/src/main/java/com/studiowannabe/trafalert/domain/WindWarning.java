package com.studiowannabe.trafalert.domain;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Created by Tomi on 31/01/16.
 *
 * Wind warning is issued when wind speeds exceed 20 m/s on average.
 * For gusts same limits apply.
 */
public @Data
class WindWarning implements Warning {

    private final WarningType warningType;
    private final LocalDateTime beginTime;
    private final BigDecimal windSpeed;

    /**
     * Same class is used for both average wind warning and gusts.
     * Average warning obvivously should override gust warning
     * @return
     */
    @Override
    public WarningType getWarningType() {
        return null;
    }

    @Override
    public LocalDateTime getBeginTime() {
        return null;
    }
}
