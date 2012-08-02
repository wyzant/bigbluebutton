package org.bigbluebutton.modules.whiteboard.models
{	
	import mx.collections.ArrayCollection;	
	import org.bigbluebutton.common.LogUtil;

	public class Presentation
	{
		private var _id:String;
		private var _numPages:int;
		
		private var _pages:ArrayCollection = new ArrayCollection();
		private var _currentPage:Page;
		
		public function Presentation(id:String, numPages:int)
		{
			_id = id;
			_numPages = numPages;
            createPages(numPages);
		}
		
        public function getAnnotations():Array {
            return _currentPage.getAnnotations();
        }
        
        public function getAnnotation(id:String):Annotation {
            return _currentPage.getAnnotation(id);
        }
        
		private function createPages(numPages:int):void {
            LogUtil.debug("**** Creating presentation " + _id + " with pages [" + numPages + "]");
			for (var i:int = 1; i <= numPages; i++) {
                LogUtil.debug("**** Creating page [" + i + "]");
				_pages.addItem(new Page(i));
			}
		}
		
		public function setCurrentPage(num:int):void {
            LogUtil.debug("**** Setting current page to [" + num + "]. Num page = [" + _pages.length + "]");
            var found:Boolean = false;
            var idx:int = -1;
			for (var i:int = 0; i < _numPages && !found; i++) {
				var p:Page = _pages.getItemAt(i) as Page;
                if (p.number == num) {
                    idx = i;
                    found = true;
                }
			}			
            if (found) {
                _currentPage = _pages.getItemAt(idx) as Page;
                LogUtil.debug("**** Current page to [" + _currentPage.number + "]");                
            } else {
                LogUtil.error("Cannot find page [" + num + "] in presentation [" + _id + "]");
            }

		}
		
		public function addAnnotation(annotation:Annotation):void {
			_currentPage.addAnnotation(annotation);
		}
		
        public function updateAnnotation(annotation:Annotation):void {
            _currentPage.updateAnnotation(annotation);
        }
        
		public function undo():void {
			_currentPage.undo();
		}
		
		public function clear():void {
			_currentPage.clear();
		}
		
		public function get id():String {
			return _id;
		}
	}
}