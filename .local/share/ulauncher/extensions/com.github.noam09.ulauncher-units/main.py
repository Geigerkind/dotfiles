import logging
from ulauncher.api.client.Extension import Extension
from ulauncher.api.client.EventListener import EventListener
from ulauncher.api.shared.event import KeywordQueryEvent
from ulauncher.api.shared.item.ExtensionResultItem import ExtensionResultItem
from ulauncher.api.shared.item.SmallResultItem import SmallResultItem
from ulauncher.api.shared.action.RenderResultListAction import RenderResultListAction
from ulauncher.api.shared.action.CopyToClipboardAction import CopyToClipboardAction
from pint import UnitRegistry

ureg = UnitRegistry(autoconvert_offset_to_baseunit=True)
Q_ = ureg.Quantity

logging.basicConfig()
logger = logging.getLogger(__name__)


class UnitsExtension(Extension):
    def __init__(self):

        super(UnitsExtension, self).__init__()
        self.subscribe(KeywordQueryEvent, KeywordQueryEventListener())


class KeywordQueryEventListener(EventListener):
    def on_event(self, event, extension):
        # Get query
        term = (event.get_argument() or '')
        elem = term.split(' to ')
        if len(elem) > 1:
            src, dst = term.split(' to ')
        # Try to handle the "in" conversion keyword
        # Becomes an issue when user also wants to convert inches as "in"
        else:
            elem = term.split(' in ')
            # The second condition occurs when the user want to convert to inches
            if term.endswith(' in in'):
                src, dst = term.split(' in ')
            elif ' in in ' in term:
                src, dst = term.split(' in in ')
                src += ' in'
            elif len(elem) > 1:
                src, dst = term.split(' in ')
        try:
            src = ureg.parse_expression(src, case_sensitive=False)
            dst = ureg.parse_expression(dst, case_sensitive=False)
            result = description = str(src.to(dst))
        except Exception as e:
            result = description = "No result"

        return_list = [create_item(result, "icon", "", "", "")]
        return RenderResultListAction(return_list)


def create_item(name, icon, keyword, description, on_enter):
    return ExtensionResultItem(
            name=name,
            description=description,
            icon='images/{}.svg'.format(icon),
            on_enter=CopyToClipboardAction(description)
    )


if __name__ == '__main__':
    UnitsExtension().run()
