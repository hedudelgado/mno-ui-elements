angular.module 'mnoUiElements'
  .service 'Notifications', ($log, toastr, MnoeNotifications) ->

    NOTIFICATION_TYPE_MAPPING = {
      reminder: 'info',
      due: 'warning',
      completed: 'info',
    }

    @init = () ->
      $log.debug("Notifications are enabled")
      MnoeNotifications.get().then(
        (response)->
          notifications = response.data.plain()
          for notification in notifications
            notification_type = notification.notification_type
            method = NOTIFICATION_TYPE_MAPPING[notification_type]
            message = notification.message.split("\n").join("</br>")
            title = notification.title
            onHidden = ->
              params = {object_id: notification.object_id, object_type: notification.object_type, notification_type: notification_type}
              MnoeNotifications.notified(params)
            toastr[method](message,title, {
              closeButton: true,
              autoDismiss: false,
              tapToDismiss: true,
              timeOut: 0,
              extendedTimeOut: 0,
              onHidden: onHidden,
              allowHtml: true
            })
        (errors)->
          $log.error(errors)
      )

    return @
