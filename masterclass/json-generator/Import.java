import java.io.*;
import java.util.*; 

/**
 * 
 * @author phongn
 *
 */
class Import {
	
	/**
	 * 
	 * @param args Directory containing the events 
	 */
	public static void main(String args[]) throws IOException {
		String path = "/Users/phongn/cms/j-psi/Events/Run_140124"; 
		String outputPath = "/Users/phongn/cms/j-psi/json/run-140124/";
		
		File dir = new File(path);
		
		if (!dir.isDirectory()) {
			throw new IOException("Cannot read the specified directory: " + path);
		}
		for (File f : dir.listFiles()) {
			// log 
			System.out.println("Processing: " + f.getName()); 
			
			// load file 			
			BufferedInputStream bis = new BufferedInputStream(new FileInputStream(f)); 
			
			File jsonFile = new File(outputPath + f.getName() + ".json"); 
			BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(jsonFile)); 
			
			// write to file
			byte[] buf = new byte[16384];
		    int len = bis.read(buf);
		    bos.write('(');
		    while (len >= 0) {
		        for (int i = 0; i < len; i++) {
		        	byte c = buf[i];
		        	switch (c) {
		        	    case '(':
		        	        c = '[';
		        	        break;
		        	    case ')':
		        	        c = ']';
		        	    	break;
		        	}
		        	bos.write(c);
		        }
		        len = bis.read(buf);
		    }
		    bos.write(')');
			
			// done 
			bos.close(); 
			bis.close();
		}
	}
}