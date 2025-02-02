import log from "../utils/log";
import TimeParser from "../utils/time_parser.js";
import BinxMapping from "./binx_mapping.js";
import BinxAdmin from "./admin/binx_admin.js";
import BinxAppOrgExport from "./binx_org_export.js";
import BinxAppOrgMessages from "./binx_org_messages.js";
import BinxAppOrgBikes from "./binx_org_bikes.js";
import BinxAppOrgUserForm from "./binx_org_user_form";

window.binxApp || (window.binxApp = {});

binxApp.enableFilenameForUploads = function() {
  $("input.custom-file-input[type=file]").on("change", function(e) {
    // The issue is that the files list isn't actually an array. So we can't map it
    let files = [];
    let i = 0;
    while (i < e.target.files.length) {
      files.push(e.target.files[i].name);
      i++;
    }
    $(this)
      .parent()
      .find(".custom-file-label")
      .text(files.join(", "));
  });
};

// I've made the choice to have classes' first letter capitalized
// and make the instance of class (which I'm storing on window) the same name without the first letter capitalized
// I'm absolutely sure there is a best practice that I'm ignoring, but just doing it for now.
$(document).ready(function() {
  window.timeParser = new TimeParser();
  window.timeParser.localize();
  // Load admin, whatever
  if ($("#admin-content").length > 0) {
    const binxAdmin = BinxAdmin();
    binxAdmin.init();
  }
  // Load the page specific things
  const bodyId = document.getElementsByTagName("body")[0].id;
  if (bodyId === "organized_messages_index") {
    window.binxMapping = new BinxMapping("geolocated_messages");
    window.binxAppOrgMessages = new BinxAppOrgMessages();
    binxAppOrgMessages.init();
  } else if (
    ["organized_exports_show", "organized_exports_new"].includes(bodyId)
  ) {
    window.binxAppOrgExport = new BinxAppOrgExport();
    binxAppOrgExport.init();
  } else if (bodyId === "organized_bikes_index") {
    const binxAppOrgBikes = BinxAppOrgBikes();
    binxAppOrgBikes.init();
  }
  // This can be new, edit, create or update, so just checking for the element
  if ($("#multipleUserSelect").length) {
    const binxAppOrgUserForm = BinxAppOrgUserForm();
    binxAppOrgUserForm.init();
  }
});
