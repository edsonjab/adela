$(function () {
    var setRequiredFields = function () {
        var setPrivateMandatoryFields, setPublicMandatoryFields, publicDataset;

        setPrivateMandatoryFields = function () {
            $('#dataset_publish_date').removeAttr('required');
            $("label[for='dataset_publish_date']").parent().removeClass('required');
        };

        setPublicMandatoryFields = function () {
            $('#dataset_publish_date').attr('required', 'required');
            $("label[for='dataset_publish_date']").parent().addClass('required');
        };

        publicDataset = ($('#dataset_public_access').val() === "true");

        if (publicDataset) {
            setPublicMandatoryFields();
        } else {
            setPrivateMandatoryFields();
        }
    };

    //setRequiredFields();
    //$('#dataset_public_access').change(setRequiredFields);
});

$(document).on('nested:fieldAdded', function(event){
    var updateMediaType, datasetPublishDate, showProprietaryFormatAlert;

    (updateMediaType = function() {
      var mediaType = event.field.find('.form-group .media_type_select');
      var inputText = event.field.find('.form-group input.media_type');
      var format    = event.field.find('.form-group .media_type_select option:selected').text();

      if (format == 'otro') {
        event.field.find('.form-group input.media_type').val('');
        event.field.find('.form-group input.format').val('');
        event.field.find('.form-group input.format').parent().show();
      } else {
        event.field.find('.form-group input.media_type').val(mediaType.val());
        event.field.find('.form-group input.format').val(format);
        event.field.find('.form-group input.format').parent().hide();
      }
    })();

    (
      showProprietaryFormatAlert = function () {
      var mimeType = event.field.find('.form-group .media_type_select').val();
      if (mimeType === "application/vnd.ms-excel") {
        event.field.find(".proprietary-format").removeClass("hidden");
      } else {
        event.field.find(".proprietary-format").addClass("hidden");
      }
    })();

    // sets dataset publish-date into new distribution
    datasetPublishDate = $('#dataset_publish_date').val();
    event.field.find('.publish-date').val(datasetPublishDate);

    $('.media_type_select').on('change', updateMediaType);
    $('.media_type_select').on('change', showProprietaryFormatAlert);
    $('.datepicker').datepicker();
    $('[data-toggle="tooltip"]').tooltip();
})
