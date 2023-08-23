from sklearn.cluster import KMeans
import scipy.io as scio
from os import listdir
import csv
import time

class KMeansProgress():
    kmeans_handler = None
    n_checkpoints = None
    progress_path = None
    progress_path_file = None

    def __init__(self, n_clusters, init, n_init, progress_path, n_checkpoints):
        if n_checkpoints > n_init:
            raise Exception("Total number of replicates should be bigger than the number of checkpoints")
        if n_init % n_checkpoints != 0:
            raise Exception("The number of checkpoints should divide exactly the number of replicates")

        self.progress_path_file = "{}/{}".format(progress_path, "progress.csv")
        f = open(self.progress_path_file, "a")
        f.close()

        self.kmeans_handler = KMeans(
            n_clusters = n_clusters,
            init = init,
            n_init = n_init//n_checkpoints
        )

        self.progress_path = progress_path
        self.n_checkpoints = n_checkpoints
    
    def get_last_checkpoint(self):
        with open(self.progress_path_file) as csv_file:
            progress_info = list(csv.reader(csv_file, delimiter=','))
            if len(progress_info) > 0:
                try:
                    checkpoint = int(progress_info[-1][0])
                except:
                    checkpoint = int(progress_info[-2][0])
            else:
                checkpoint = 0
        
        return checkpoint
    
    def write_checkpoint(self, checkpoint, sse):
        with open(self.progress_path_file, mode='a') as csv_file:
            csv_writer = csv.writer(csv_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL, lineterminator='\n')
            csv_writer.writerow([checkpoint, sse])
        
    def get_best_sse(self):
        minimum = None
        minimum_checkpoint = 1
        with open(self.progress_path_file) as csv_file:
            progress_info = list(csv.reader(csv_file, delimiter=','))
            for p in progress_info:
                sse = float(p[1])
                if minimum is None:
                    minimum = sse
                if sse < minimum:
                    minimum = sse
                    minimum_checkpoint = int(p[0])

        return minimum_checkpoint, minimum

    def fit(self, dataset):
        checkpoint = self.get_last_checkpoint()
        
        checkpoint_counter = checkpoint
        for c in range(checkpoint+1, self.n_checkpoints+1):
            km = self.kmeans_handler.fit(dataset)
            sse = km.inertia_
            centers = km.cluster_centers_
            self.write_checkpoint(c, sse)
            scio.savemat("{}/{}.mat".format(self.progress_path, c), {'C': centers})
            print("Finished iteration {}/{}".format(c, self.n_checkpoints))
            checkpoint_counter += 1
        
        if checkpoint_counter == self.n_checkpoints:
            best_checkpoint, best_sse = self.get_best_sse()
            message = "Best centroid was {} with SSE = {}".format(best_checkpoint, best_sse)
            f = open("{}/output.txt".format(self.progress_path), 'w')
            f.write(message)
            f.close()
            print(message)

        